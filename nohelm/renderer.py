"""Walk a Folder tree, emit plain kustomize + yaml. The only I/O lives here."""
from __future__ import annotations
from pathlib import Path
from typing import Any
import yaml

from model import (
    App, Container, Config, Secret, Mount, Port, Ingress,
    Options, ServiceAccount, PolicyRule, Folder, Node,
)


# ---------- defaults ----------

DEFAULT_TOLERATIONS = [
    {"key": "node.kubernetes.io/not-ready",   "operator": "Exists",
     "effect": "NoExecute", "tolerationSeconds": 10},
    {"key": "node.kubernetes.io/unreachable", "operator": "Exists",
     "effect": "NoExecute", "tolerationSeconds": 10},
]
GPU_TOLERATION = {"key": "nvidia.com/gpu", "operator": "Exists",
                  "effect": "NoSchedule"}


# ---------- yaml helpers ----------

def _clean(d: Any) -> Any:
    if isinstance(d, dict):
        return {k: _clean(v) for k, v in d.items() if v not in (None, [], {}, ())}
    if isinstance(d, (list, tuple)):
        return [_clean(x) for x in d]
    return d


def dump(path: Path, *docs: dict) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    text = "---\n".join(
        yaml.safe_dump(_clean(d), sort_keys=False, default_flow_style=False)
        for d in docs if d
    )
    path.write_text(text)


def labels(app: App) -> dict:
    return {"app": app.name}


# ---------- containers ----------

def render_container(c: Container) -> dict:
    d: dict = {"name": c.name, "image": c.image}
    if c.cmd:  d["command"] = list(c.cmd)
    if c.args: d["args"] = list(c.args)

    if c.ports:
        d["ports"] = [
            {"name": p.name, "containerPort": p.number, "protocol": p.proto}
            for p in c.ports
        ]

    if c.config or c.secret:
        refs = []
        if c.config: refs.append({"configMapRef": {"name": "config"}})
        if c.secret: refs.append({"secretRef":   {"name": "secret"}})
        d["envFrom"] = refs

    if c.mounts:
        d["volumeMounts"] = [
            {"name": m.name, "mountPath": m.at,
             **({"readOnly": True} if m.ro else {})}
            for m in c.mounts
        ]

    limits: dict = {}
    if c.cpu: limits["cpu"] = c.cpu
    if c.mem: limits["memory"] = c.mem
    if limits:
        d["resources"] = {"limits": limits, "requests": limits}

    return d


# ---------- pod spec ----------

def build_pod_spec(app: App) -> tuple[dict, dict, list[dict]]:
    """Return (pod_metadata, pod_spec, extra_yaml_docs)."""
    meta: dict = {"labels": labels(app)}
    if app.options.linkerd:
        meta["annotations"] = {"linkerd.io/inject": "enabled"}

    spec: dict = {
        "containers": [render_container(c) for c in app.containers],
    }
    if app.service_account:
        spec["serviceAccountName"] = app.service_account.name

    tolerations = list(app.tolerations) if app.tolerations else list(DEFAULT_TOLERATIONS)
    if app.options.gpu:
        tolerations.append(GPU_TOLERATION)
    if tolerations:
        spec["tolerations"] = tolerations

    # volumes (emptyDir or PVC)
    volumes: list[dict] = []
    for c in app.containers:
        for m in c.mounts:
            if m.size and app.options.storage != "none":
                volumes.append({"name": m.name,
                                "persistentVolumeClaim":
                                    {"claimName": f"pvc-{m.name}"}})
            else:
                volumes.append({"name": m.name, "emptyDir": {}})
    if volumes:
        spec["volumes"] = volumes

    return meta, spec, []


# ---------- workload ----------

def render_workload(app: App) -> dict:
    meta, spec, _ = build_pod_spec(app)
    kind_file = {
        "Deployment":  "deployment.yaml",
        "DaemonSet":   "daemonset.yaml",
        "StatefulSet": "statefulset.yaml",
    }[app.kind]

    s: dict = {
        "selector": {"matchLabels": labels(app)},
        "template": {"metadata": meta, "spec": spec},
    }
    if app.kind in ("Deployment", "StatefulSet"):
        s["replicas"] = app.replicas
    if app.kind == "StatefulSet":
        s["serviceName"] = app.name

    return {
        "apiVersion": "apps/v1",
        "kind": app.kind,
        "metadata": {"name": app.name, "labels": labels(app)},
        "spec": s,
    }


# ---------- service ----------

def render_service(app: App) -> dict | None:
    ports = [p for c in app.containers for p in c.ports if p.expose]
    if not ports:
        return None
    return {
        "apiVersion": "v1",
        "kind": "Service",
        "metadata": {"name": app.name, "labels": labels(app)},
        "spec": {
            "selector": labels(app),
            "ports": [
                {"name": p.name, "port": p.number, "targetPort": p.name}
                for p in ports
            ],
        },
    }


# ---------- ingress ----------

def render_ingress(app: App) -> dict | None:
    if not app.ingress:
        return None
    ann: dict = {}
    if app.ingress.auth:
        ann["traefik.ingress.kubernetes.io/router.middlewares"] = \
            f"{app.ingress.auth}@kubernetescrd"
    doc = {
        "apiVersion": "networking.k8s.io/v1",
        "kind": "Ingress",
        "metadata": {"name": app.name, "labels": labels(app),
                     **({"annotations": ann} if ann else {})},
        "spec": {
            "rules": [{
                "host": app.ingress.host,
                "http": {"paths": [{
                    "path": "/", "pathType": "Prefix",
                    "backend": {"service": {
                        "name": app.name,
                        "port": {"name": app.ingress.port},
                    }},
                }]},
            }],
        },
    }
    if app.ingress.tls:
        doc["spec"]["tls"] = [{"hosts": [app.ingress.host],
                               "secretName": f"{app.name}-tls"}]
    return doc


# ---------- RBAC ----------

def render_rbac(app: App) -> dict[str, dict]:
    sa = app.service_account
    if sa is None:
        return {}
    out: dict[str, dict] = {
        "sa.yaml": {
            "apiVersion": "v1",
            "kind": "ServiceAccount",
            "metadata": {"name": sa.name, **({"namespace": app.namespace}
                                             if app.namespace else {})},
        },
    }
    if not sa.needs_cluster_role:
        return out

    role_name = sa.cluster_role_name or f"{app.name}-role"
    bind_name = sa.binding_name     or f"{app.name}-rb"

    out["cluster-role.yaml"] = {
        "apiVersion": "rbac.authorization.k8s.io/v1",
        "kind": "ClusterRole",
        "metadata": {"name": role_name},
        "rules": [
            {k: v for k, v in {
                "verbs":           r.verbs,
                "apiGroups":       r.api_groups,
                "resources":       r.resources,
                "resourceNames":   r.resource_names,
                "nonResourceURLs": r.non_resource_urls,
            }.items() if v}
            for r in sa.rules
        ],
    }
    subject: dict = {"kind": "ServiceAccount", "name": sa.name}
    if app.namespace:
        subject["namespace"] = app.namespace
    out["cluster-role-binding.yaml"] = {
        "apiVersion": "rbac.authorization.k8s.io/v1",
        "kind": "ClusterRoleBinding",
        "metadata": {"name": bind_name},
        "roleRef": {"apiGroup": "rbac.authorization.k8s.io",
                    "kind": "ClusterRole", "name": role_name},
        "subjects": [subject],
    }
    return out


# ---------- linkerd ----------

def render_linkerd(app: App) -> dict | None:
    if not app.options.linkerd:
        return None
    port_name = app.containers[0].ports[0].name if app.containers[0].ports else "http"
    return {
        "apiVersion": "policy.linkerd.io/v1alpha1",
        "kind": "Server",
        "metadata": {"name": app.name},
        "spec": {"podSelector": {"matchLabels": labels(app)},
                 "port": port_name, "proxyProtocol": "HTTP/2"},
    }


# ---------- storage ----------

def render_storage(app: App) -> dict[str, dict]:
    out: dict[str, dict] = {}
    store = app.options.storage
    if store == "none":
        return out

    for c in app.containers:
        for m in c.mounts:
            if not m.size:
                continue
            pv_name  = f"{app.name}-{m.name}-{store}"
            pvc_name = f"pvc-{m.name}"
            out.setdefault(f"pv-{store}.yaml", {"__multi__": []})
            out.setdefault(f"pvc-{store}.yaml", {"__multi__": []})

            out[f"pv-{store}.yaml"]["__multi__"].append({
                "apiVersion": "v1", "kind": "PersistentVolume",
                "metadata": {"name": pv_name},
                "spec": {
                    "capacity": {"storage": m.size},
                    "accessModes": ["ReadWriteMany"],
                    "persistentVolumeReclaimPolicy": "Retain",
                    "storageClassName": store,
                    "csi": {"driver": f"{store}.csi.k8s.io",
                            "volumeHandle": pv_name},
                },
            })
            out[f"pvc-{store}.yaml"]["__multi__"].append({
                "apiVersion": "v1", "kind": "PersistentVolumeClaim",
                "metadata": {"name": pvc_name},
                "spec": {
                    "accessModes": ["ReadWriteMany"],
                    "storageClassName": store,
                    "resources": {"requests": {"storage": m.size}},
                },
            })
    return out


# ---------- env files ----------

def collect_configs(app: App) -> tuple[list[Config], list[Secret]]:
    cfgs, secs = [], []
    for c in app.containers:
        cfgs.extend(c.config)
        secs.extend(c.secret)
    return cfgs, secs


def write_env_files(d: Path, app: App) -> dict:
    cfgs, secs = collect_configs(app)
    written: dict = {}
    if cfgs:
        (d / "config.env").write_text(
            "\n".join(f"{c.key}={c.value}" for c in cfgs) + "\n")
        written["config.env"] = True
    if secs:
        (d / "secret.env").write_text(
            "\n".join(f"{s.key}={s.value}" for s in secs) + "\n")
        written["secret.env"] = True
    return written


# ---------- kustomization ----------

def write_app_kustomization(d: Path, yaml_files: list[str],
                            env_files: dict) -> None:
    k: dict = {
        "apiVersion": "kustomize.config.k8s.io/v1beta1",
        "kind": "Kustomization",
        "resources": sorted(yaml_files),
    }
    gen = []
    if env_files.get("config.env"):
        gen.append({"name": "config", "envs": ["config.env"]})
    if env_files.get("secret.env"):
        gen.append({"name": "secret", "envs": ["secret.env"]})
    if gen:
        k["configMapGenerator"] = [g for g in gen if g["name"] == "config"]
        k["secretGenerator"]    = [g for g in gen if g["name"] == "secret"]
        k["configMapGenerator"] = k.get("configMapGenerator") or None
        k["secretGenerator"]    = k.get("secretGenerator")    or None
        if k["configMapGenerator"] is None: del k["configMapGenerator"]
        if k["secretGenerator"]    is None: del k["secretGenerator"]
    dump(d / "kustomization.yaml", k)


def write_folder_kustomization(d: Path, node: Folder) -> None:
    resources = []
    for child in node.children:
        resources.append(child.name)
    for f in sorted(d.glob("*.yaml")):
        if f.name != "kustomization.yaml":
            resources.append(f.name)
    if not resources:
        return
    dump(d / "kustomization.yaml", {
        "apiVersion": "kustomize.config.k8s.io/v1beta1",
        "kind": "Kustomization",
        "resources": sorted(resources),
    })


# ---------- one app ----------

def render_app(app: App, base: Path) -> None:
    d = base / app.name
    d.mkdir(parents=True, exist_ok=True)

    yamls: dict[str, dict | list] = {}
    yamls[f"{app.kind.lower()}.yaml"] = render_workload(app)

    svc = render_service(app)
    if svc: yamls["service.yaml"] = svc

    ing = render_ingress(app)
    if ing: yamls["ingress.yaml"] = ing

    rbac = render_rbac(app)
    yamls.update(rbac)

    lk = render_linkerd(app)
    if lk: yamls["linkerd-policies.yaml"] = lk

    storage = render_storage(app)
    # storage dicts may have __multi__ lists
    flat_yamls: list[str] = []
    for fname, doc in yamls.items():
        dump(d / fname, doc)
        flat_yamls.append(fname)
    for fname, doc in storage.items():
        if isinstance(doc, dict) and "__multi__" in doc:
            dump(d / fname, *doc["__multi__"])
        else:
            dump(d / fname, doc)
        flat_yamls.append(fname)

    env_files = write_env_files(d, app)
    write_app_kustomization(d, flat_yamls, env_files)


# ---------- walk ----------

def render_node(node: Node, base: Path) -> None:
    if isinstance(node, Folder):
        d = base / node.name
        d.mkdir(parents=True, exist_ok=True)
        for child in node.children:
            render_node(child, d)
        write_folder_kustomization(d, node)
    else:
        render_app(node, base)


def render(tree: Folder, root: Path | None = None) -> None:
    root = root or Path(tree.name)
    root.mkdir(parents=True, exist_ok=True)
    for child in tree.children:
        render_node(child, root)
    write_folder_kustomization(root, tree)