#!/usr/bin/env python3
"""
scan.py — import existing kustomize apps into model.py dataclasses.

Layout convention (matches yours):

    <root>/
      <env>/             # prod, test, ...      (optional)
        <ns>/            # public, dmz, private, main
          [folders/]
            <app>/       # contains kustomization.yaml
              kustomization.yaml
              deployment.yaml
              service.yaml
              ...

Usage:
    python scan.py <root>              # walk tree, print tree.py to stdout
    python scan.py <root> -o tree.py   # write to file
    python scan.py <app-dir> --flat    # emit a single App(...)
"""
from __future__ import annotations

import argparse
import re
import sys
from dataclasses import MISSING, fields, is_dataclass
from pathlib import Path
from typing import Any

import yaml

try:
    import model as m
except ImportError:
    print("error: model.py must be importable from cwd", file=sys.stderr)
    sys.exit(2)


# ---------- template conventions (things we DON'T emit) ----------

ENVIRONMENTS = {"prod", "test", "staging", "dev"}
NAMESPACES   = {"public", "dmz", "private", "main", "default"}
WORKLOAD_KINDS = {"Deployment", "DaemonSet", "StatefulSet"}

# From daemonset.yaml / deployment.yaml templates — if a real file matches
# this exactly, we leave it out of the model so the template keeps applying it.
DEFAULT_TOLERATIONS = [
    {"key": "node.kubernetes.io/not-ready", "operator": "Exists",
     "effect": "NoExecute", "tolerationSeconds": 10},
    {"key": "node.kubernetes.io/unreachable", "operator": "Exists",
     "effect": "NoExecute", "tolerationSeconds": 10},
]

# Middleware suffix that ingress.yaml applies by default.
DEFAULT_AUTH_SUFFIX = "-middleware-auth-authentik"


# ---------- yaml loading ----------

def load_docs(path: Path) -> list[dict]:
    try:
        text = path.read_text()
    except OSError as e:
        print(f"  ! cannot read {path}: {e}", file=sys.stderr)
        return []
    try:
        docs = list(yaml.safe_load_all(text))
    except yaml.YAMLError as e:
        print(f"  ! yaml error in {path}: {e}", file=sys.stderr)
        return []
    return [d for d in docs if isinstance(d, dict)]


# ---------- bundle: everything belonging to one app ----------

class Bundle:
    def __init__(self, path: Path):
        self.path = path
        self.kustomization: dict = {}
        self.docs: list[dict] = []

    def by_kind(self, *kinds: str) -> list[dict]:
        s = set(kinds)
        return [d for d in self.docs if d.get("kind") in s]

    @property
    def workloads(self):       return self.by_kind(*WORKLOAD_KINDS)
    @property
    def services(self):        return self.by_kind("Service")
    @property
    def ingresses(self):       return self.by_kind("Ingress", "IngressRoute")
    @property
    def service_account(self): return (self.by_kind("ServiceAccount") or [None])[0]
    @property
    def cluster_role(self):    return (self.by_kind("ClusterRole") or [None])[0]
    @property
    def hpa(self):             return (self.by_kind("HorizontalPodAutoscaler") or [None])[0]
    @property
    def pvc(self):             return (self.by_kind("PersistentVolumeClaim") or [None])[0]
    @property
    def pv(self):              return (self.by_kind("PersistentVolume") or [None])[0]


AUTO_FILES = [
    "deployment.yaml", "daemonset.yaml", "statefulset.yaml",
    "service.yaml", "ingress.yaml", "sa.yaml",
    "cluster-role.yaml", "cluster-role-binding.yaml",
    "scaler.yaml", "pvc.yaml", "pv.yaml",
]


def walk_kustomizations(root: Path, skip: set[str]) -> list[Path]:
    out: list[Path] = []
    seen: set[Path] = set()
    for name in ("kustomization.yaml", "kustomization.yml"):
        for p in sorted(root.rglob(name)):
            rel = p.relative_to(root)
            # skip hidden dirs anywhere under root
            if any(part.startswith(".") for part in rel.parts):
                continue
            # skip only if the directory holding kustomization.yaml is named
            # like a kustomize *base* — not any ancestor dir
            if p.parent.name in skip:
                continue
            if p.parent in seen:
                continue
            seen.add(p.parent)
            out.append(p.parent)
    return out


def load_bundle(app_dir: Path) -> Bundle:
    bundle = Bundle(app_dir)
    for name in ("kustomization.yaml", "kustomization.yml"):
        k = app_dir / name
        if k.exists():
            bundle.kustomization = yaml.safe_load(k.read_text()) or {}
            break

    seen: set[Path] = set()

    # 1. explicit resources / bases referenced from kustomization.yaml
    refs = list(bundle.kustomization.get("resources", []) or [])
    refs += list(bundle.kustomization.get("bases", []) or [])
    for ref in refs:
        p = (app_dir / ref).resolve()
        if p.is_dir():
            for y in sorted(p.glob("*.y*ml")):
                if y.name.startswith("kustomization"):
                    continue
                if y in seen:
                    continue
                seen.add(y)
                bundle.docs.extend(load_docs(y))
        elif p.is_file() and p.suffix in (".yaml", ".yml"):
            if p in seen:
                continue
            seen.add(p)
            bundle.docs.extend(load_docs(p))

    # 2. well-known filenames in the same dir
    for fname in AUTO_FILES:
        f = app_dir / fname
        if f.exists() and f not in seen:
            seen.add(f)
            bundle.docs.extend(load_docs(f))

    return bundle


# ---------- inference ----------

def infer_app_name(bundle: Bundle) -> str:
    # "app: <ns>-<name>" label is the canonical source
    for w in bundle.workloads:
        labels = (w.get("spec", {}).get("template", {})
                    .get("metadata", {}).get("labels", {}))
        app = labels.get("app")
        if app and "-" in app:
            return app.split("-", 1)[1]
        if app:
            return app
    # kustomize namePrefix "<name>-"
    prefix = bundle.kustomization.get("namePrefix", "")
    if prefix.endswith("-"):
        return prefix[:-1]
    if prefix:
        return prefix
    return bundle.path.name


def infer_namespace(bundle: Bundle) -> str:
    for d in bundle.docs:
        ns = d.get("metadata", {}).get("namespace")
        if ns:
            return ns
    ns = bundle.kustomization.get("namespace")
    if ns:
        return ns
    return "default"


def infer_storage(bundle: Bundle) -> str:
    pvc = bundle.pvc
    if not pvc:
        return "none"
    sc = pvc.get("spec", {}).get("storageClassName")
    return "nfs" if sc == "nfs" else "cephfs"


# ---------- builder ----------

def build_app(bundle: Bundle) -> m.App:
    name = infer_app_name(bundle)
    namespace = infer_namespace(bundle)

    workload = bundle.workloads[0] if bundle.workloads else {}
    kind = workload.get("kind", "Deployment")
    replicas = workload.get("spec", {}).get("replicas", 1)
    pod_spec = (workload.get("spec", {})
                       .get("template", {})
                       .get("spec", {}))

    tol = pod_spec.get("tolerations", [])
    tolerations = [] if tol == DEFAULT_TOLERATIONS else tol

    volumes_by_name = {v["name"]: v for v in pod_spec.get("volumes", []) if "name" in v}
    cm_gen = {g["name"]: g for g in bundle.kustomization.get("configMapGenerator", [])}
    sm_gen = {g["name"]: g for g in bundle.kustomization.get("secretGenerator", [])}

    cdefs: list[dict] = []
    for ic in pod_spec.get("initContainers", []):
        if ic.get("restartPolicy") == "Always":     # sidecar
            cdefs.append(ic)
    cdefs.extend(pod_spec.get("containers", []))

    pvc_size: str | None = None
    if bundle.pvc:
        pvc_size = (bundle.pvc.get("spec", {})
                              .get("resources", {})
                              .get("requests", {})
                              .get("storage"))
    storage_type = infer_storage(bundle)

    containers = [
        build_container(c, name, volumes_by_name, cm_gen, sm_gen,
                        pvc_size, storage_type)
        for c in cdefs
    ]

    app = m.App(
        name=name,
        containers=containers,
        kind=kind,
        replicas=replicas,
        options=m.Options(
            storage=storage_type,
            hpa=bundle.hpa is not None,
            ingress=len(bundle.ingresses) > 0,
            service=len(bundle.services) > 0,
        ),
        ingress=build_ingress(bundle, name, namespace),
        tolerations=tolerations,
        service_account=build_sa(bundle),
    )

    resolve_service_ports(app, bundle)
    return app


def build_container(
    c: dict,
    app_name: str,
    volumes_by_name: dict[str, dict],
    cm_gen: dict[str, dict],
    sm_gen: dict[str, dict],
    pvc_size: str | None,
    storage_type: str,
) -> m.Container:
    name  = c.get("name", app_name)
    image = c.get("image", "")

    ports: list[m.Port] = []
    for p in c.get("ports", []):
        num = p.get("containerPort")
        if num is None:
            continue
        ports.append(m.Port(
            number=int(num),
            name=p.get("name", "http"),
            proto=p.get("protocol", "TCP"),
        ))

    env: dict[str, str] = {}
    for e in c.get("env", []):
        if "name" in e and "value" in e:
            env[e["name"]] = str(e["value"])

    res = c.get("resources") or {}
    req = res.get("requests") or {}

    mounts: list = []
    for vm in c.get("volumeMounts", []):
        vname = vm["name"]
        at    = vm["mountPath"]
        sub   = vm.get("subPath")
        ro    = bool(vm.get("readOnly", False))
        src   = volumes_by_name.get(vname, {})

        if "configMap" in src:
            cm_name = src["configMap"].get("name", vname)
            gen = cm_gen.get(cm_name, {})
            file = "config.yaml"
            for f in gen.get("files", []) or []:
                file = f.split("=", 1)[1] if "=" in f else f
                break
            mounts.append(m.Config(name=cm_name, at=at, file=file, ro=ro))

        elif "secret" in src:
            s_name = src["secret"].get("secretName", vname)
            gen = sm_gen.get(s_name, {})
            envs = gen.get("envs", []) or []
            env_file = envs[0] if envs else "secret.env"
            mounts.append(m.SecretMount(name=s_name, at=at, env_file=env_file, ro=ro))

        elif "persistentVolumeClaim" in src:
            mounts.append(m.Volume(
                name=vname, at=at, size=pvc_size, storage=storage_type,
                sub_path=sub, ro=ro,
            ))

        elif "hostPath" in src:
            mounts.append(m.Volume(
                name=vname, at=at,
                host_path=src["hostPath"].get("path", ""), ro=ro,
            ))

        elif "emptyDir" in src:
            mounts.append(m.Volume(name=vname, at=at, ro=ro))

    return m.Container(
        image=image,
        name=None if name == app_name else name,
        ports=ports,
        mounts=mounts,
        env=env,
        cpu=req.get("cpu"),
        mem=req.get("memory"),
    )


def resolve_service_ports(app: m.App, bundle: Bundle) -> None:
    """Attach Service.port to matching container ports when they differ."""
    if not bundle.services:
        return
    lookup: dict = {}
    for svc in bundle.services:
        for sp in svc.get("spec", {}).get("ports", []) or []:
            tp = sp.get("targetPort")
            nm = sp.get("name")
            pt = sp.get("port")
            if tp is not None: lookup[tp] = pt
            if nm:             lookup[nm] = pt
    for c in app.containers:
        for p in c.ports:
            svc_port = lookup.get(p.number) or lookup.get(p.name)
            if svc_port is not None and int(svc_port) != p.number:
                p.service_port = int(svc_port)


def build_ingress(bundle: Bundle, app_name: str, namespace: str) -> m.Ingress | None:
    if not bundle.ingresses:
        return None
    spec = bundle.ingresses[0].get("spec", {})
    routes = spec.get("routes") or []

    host = ""
    if routes:
        mo = re.search(r"Host\(`([^`]+)`\)", routes[0].get("match", ""))
        if mo:
            host = mo.group(1)
    else:
        rules = spec.get("rules") or []
        if rules:
            host = rules[0].get("host", "")

    # Host is auto-generated by the renderer when it matches convention.
    if not host or host == f"{app_name}.{namespace}.home":
        return None

    auth = None
    if routes:
        for mw in routes[0].get("middlewares", []) or []:
            n = mw.get("name", "")
            if n.endswith(DEFAULT_AUTH_SUFFIX):
                continue
            auth = n
            break

    return m.Ingress(host=host, auth=auth)


def build_sa(bundle: Bundle) -> m.ServiceAccount | None:
    sa_doc = bundle.service_account
    cr_doc = bundle.cluster_role
    if sa_doc is None and cr_doc is None:
        return None
    sa_name = (sa_doc or {}).get("metadata", {}).get("name", "sa")
    rules: list[m.PolicyRule] = []
    if cr_doc:
        for r in cr_doc.get("rules", []) or []:
            rules.append(m.PolicyRule(
                verbs=r.get("verbs", []),
                api_groups=r.get("apiGroups", [""]),
                resources=r.get("resources", []),
                resource_names=r.get("resourceNames", []),
                non_resource_urls=r.get("nonResourceURLs", []),
            ))
    if sa_name == "sa" and not rules:
        return None      # default SA → implicit
    return m.ServiceAccount(name=sa_name, rules=rules)


# ---------- source rendering ----------

def _default_of(f):
    if f.default is not MISSING:
        return f.default
    if f.default_factory is not MISSING:
        try:
            return f.default_factory()
        except Exception:
            return MISSING
    return MISSING


def q(s: str) -> str:
    """Python string literal, preferring double quotes."""
    if '"' not in s and "\\" not in s:
        return f'"{s}"'
    return repr(s)


def render_any(obj: Any, indent: int = 0) -> str:
    if obj is None:              return "None"
    if isinstance(obj, bool):    return "True" if obj else "False"
    if isinstance(obj, (int, float)): return repr(obj)
    if isinstance(obj, str):     return q(obj)
    if isinstance(obj, list):    return render_list(obj, indent)
    if isinstance(obj, dict):    return render_dict(obj, indent)
    if is_dataclass(obj):        return render_model(obj, indent)
    return repr(obj)


def render_list(items: list, indent: int) -> str:
    if not items:
        return "[]"
    pad   = "    " * indent
    inner = "    " * (indent + 1)
    parts = [render_any(x, indent + 1) for x in items]
    inline = "[" + ", ".join(parts) + "]"
    has_dc = any(is_dataclass(x) for x in items)
    if all("\n" not in p for p in parts) and len(inline) < (40 if has_dc else 60):
        return inline
    body = (",\n" + inner).join(parts)
    return "[\n" + inner + body + ",\n" + pad + "]"


def render_dict(d: dict, indent: int) -> str:
    if not d:
        return "{}"
    pad   = "    " * indent
    inner = "    " * (indent + 1)
    parts = [f"{q(k)}: {render_any(v, indent + 1)}" for k, v in d.items()]
    inline = "{" + ", ".join(parts) + "}"
    if all("\n" not in p for p in parts) and len(inline) < 60:
        return inline
    body = (",\n" + inner).join(parts)
    return "{\n" + inner + body + ",\n" + pad + "}"


def render_model(obj, indent: int) -> str:
    pad      = "    " * indent
    inner    = "    " * (indent + 1)
    cls_name = "m." + type(obj).__name__

    entries: list[str] = []
    for f in fields(obj):
        v = getattr(obj, f.name)
        default = _default_of(f)
        if default is not MISSING and v == default:
            continue
        if v is None:
            continue
        entries.append(f"{f.name}={render_any(v, indent + 1)}")

    if not entries:
        return f"{cls_name}()"
    inline = ", ".join(entries)
    if "\n" not in inline and len(inline) < 50:
        return f"{cls_name}({inline})"
    body = (",\n" + inner).join(entries)
    return f"{cls_name}(\n{inner}{body},\n{pad})"


def emit_app_lines(app: m.App, base: str) -> list[str]:
    """Emit `base.app(name=..., containers=..., ...)` (kwargs form)."""
    kvs: list[tuple[str, Any]] = []
    for f in fields(app):
        v = getattr(app, f.name)
        default = _default_of(f)
        if default is not MISSING and v == default:
            continue
        if v is None:
            continue
        kvs.append((f.name, v))
    if not kvs:
        return [f"{base}.app()"]
    out = [f"{base}.app("]
    for k, v in kvs:
        out.append(f"    {k}={render_any(v, 1)},")
    out.append(")")
    return out


def emit_node(node, base: str) -> list[str]:
    if isinstance(node, m.Folder):
        return _emit_folder(node, f"{base}.folder({q(node.name)})")
    if isinstance(node, m.App):
        return [""] + emit_app_lines(node, base)
    return [f"# unhandled node: {node!r}"]


def _emit_folder(folder: m.Folder, base: str) -> list[str]:
    out: list[str] = [""]
    for c in folder.children:
        out.extend(emit_node(c, base))
    return out


def emit_tree_source(tree: m.Tree) -> str:
    lines = [
        '"""Auto-generated by scan.py — do not edit manually."""',
        "import model as m",
        "",
        "tree = m.Tree()",
    ]
    for env in tree.environments:
        lines += ["", f"# ══════ environment: {env.name} ══════"]
        for ns in env.namespaces:
            lines.append(f"# ── namespace: {ns.name} ──")
            base = f"tree.env({q(env.name)}).ns({q(ns.name)})"
            for c in ns.children:
                lines.extend(emit_node(c, base))

    if tree.main.children:
        lines += ["", "# ══════ main (default ns) ══════"]
        for c in tree.main.children:
            lines.extend(emit_node(c, "tree.main"))
    return "\n".join(lines) + "\n"


# ---------- CLI ----------

def classify_path(rel: Path) -> tuple[str | None, str, list[str]]:
    """Return (env, ns, folders) from a path relative to root."""
    parts = list(rel.parts)
    env: str | None = None
    ns:  str | None = None

    if parts and parts[0] in ENVIRONMENTS:
        env = parts.pop(0)
    if parts and parts[0] in NAMESPACES:
        ns = parts.pop(0)

    if ns is None:
        ns = "main"
    if ns == "default":
        ns = "main"

    folders = parts[:-1] if len(parts) > 1 else []
    return env, ns, folders


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("root", type=Path)
    ap.add_argument("-o", "--out", type=Path, default=None)
    ap.add_argument("--flat", action="store_true",
                    help="emit a single `app = m.App(...)` for one directory")
    ap.add_argument("--skip", action="append", default=["base", "bases"],
                    help="directory names to skip (default: base, bases)")
    args = ap.parse_args()

    root = args.root.resolve()
    if not root.exists():
        print(f"error: {root} not found", file=sys.stderr)
        return 1

    skip = set(args.skip)

    if args.flat:
        bundle = load_bundle(root)
        app = build_app(bundle)
        src = ('"""Auto-generated by scan.py."""\n'
               'import model as m\n\n'
               f"app = {render_model(app, 0)}\n")
        if args.out:
            args.out.write_text(src)
            print(f"wrote {args.out}")
        else:
            sys.stdout.write(src)
        return 0

    kdirs = walk_kustomizations(root, skip)
    if not kdirs:
        print(f"no kustomization.yaml found under {root}", file=sys.stderr)
        return 1
    print(f"found {len(kdirs)} app(s) under {root}")

    tree = m.Tree()
    for kdir in kdirs:
        rel = kdir.relative_to(root)
        env, ns, folders = classify_path(rel)
        print(f"  → {rel}   env={env!r} ns={ns!r} folders={folders}")

        try:
            bundle = load_bundle(kdir)
            app = build_app(bundle)
        except Exception as e:
            print(f"    ! failed: {e}", file=sys.stderr)
            continue

        if env is not None:
            node = tree.env(env).ns(ns)
        elif ns == "main":
            node = tree.main
        else:
            print(f"    ! skipping {rel}: ns={ns!r} but no environment",
                  file=sys.stderr)
            continue

        for fname in folders:
            node = node.folder(fname)
        node.children.append(app)

    src = emit_tree_source(tree)
    if args.out:
        args.out.write_text(src)
        print(f"wrote {args.out}")
    else:
        sys.stdout.write(src)
    return 0


if __name__ == "__main__":
    sys.exit(main())