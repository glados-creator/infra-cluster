#!/usr/bin/env python3
"""
Scan k3s_cluster/base/ for apps, detect their features, save to apps.json.

  kscan.py scan                          # (re)build apps.json from disk
  kscan.py list                          # show every app + its flags
  kscan.py show dmz/media/jellyfin       # details for one app
  kscan.py set  dmz/media/jellyfin gpu true
"""
from __future__ import annotations
import argparse, json, sys
from datetime import datetime, timezone
from pathlib import Path
import yaml

REPO = Path(__file__).resolve().parent.parent
BASE = REPO / "k3s_cluster" / "base"
DEFAULT_MANIFEST = REPO / "apps.json"

WORKLOADS = {"Deployment", "DaemonSet", "StatefulSet", "Job", "CronJob"}
SKIP_PARTS = {"template", "template-simple", ".git", "__pycache__", "node_modules"}


# ---------- yaml helpers ----------

def load_docs(path: Path) -> list[dict]:
    try:
        text = path.read_text()
    except Exception:
        return []
    try:
        return [d for d in yaml.safe_load_all(text) if isinstance(d, dict)]
    except yaml.YAMLError:
        return []


def iter_workloads(docs):
    for d in docs:
        if d.get("kind") in WORKLOADS:
            yield d


def has_top(d: Path, *names: str) -> bool:
    return any((d / n).exists() for n in names)


def has_anywhere(d: Path, *names: str) -> bool:
    for n in names:
        if next(d.rglob(n), None) is not None:
            return True
    return False


# ---------- feature detectors ----------

def detect_linkerd(app_dir: Path, docs: list[dict]) -> bool:
    if (app_dir / "linkerd-policies.yaml").exists():
        return True
    for d in iter_workloads(docs):
        ann = (d.get("spec", {})
                  .get("template", {})
                  .get("metadata", {})
                  .get("annotations") or {})
        if ann.get("linkerd.io/inject") == "enabled":
            return True
    return False


def detect_gpu(app_dir: Path, docs: list[dict]) -> bool:
    for d in iter_workloads(docs):
        containers = (d.get("spec", {})
                        .get("template", {})
                        .get("spec", {})
                        .get("containers") or [])
        for c in containers:
            limits = (c.get("resources") or {}).get("limits") or {}
            if any("gpu" in str(k).lower() for k in limits):
                return True
    return False


def detect_authentik(app_dir: Path, docs: list[dict]) -> bool:
    if has_top(app_dir,
               "middleware/auth-authentik.yaml",
               "middleware-auth-authentik.yaml"):
        return True
    for d in docs:
        if d.get("kind") != "Ingress":
            continue
        for v in (d.get("metadata", {}).get("annotations") or {}).values():
            if isinstance(v, str) and "authentik" in v.lower():
                return True
    return False


def detect_options(app_dir: Path, docs: list[dict]) -> dict:
    return {
        "linkerd":         detect_linkerd(app_dir, docs),
        "gpu":             detect_gpu(app_dir, docs),
        "authentik_auth":  detect_authentik(app_dir, docs),
        "middleware":      has_top(app_dir, "middleware",
                                   "middleware-auth-authentik.yaml",
                                   "middleware-auth-basic.yaml",
                                   "middleware-auth-trauth.yaml"),
        "ceph_pv":         has_anywhere(app_dir, "pv-cephfs.yaml", "pvc-cephfs.yaml"),
        "nfs_pv":          has_anywhere(app_dir, "pv-nfs.yaml", "pvc-nfs.yaml"),
        "service_account": has_anywhere(app_dir, "sa.yaml"),
        "cluster_role":    has_anywhere(app_dir, "cluster-role.yaml"),
        "ingress":         has_anywhere(app_dir, "ingress.yaml"),
        "daemonset":       has_anywhere(app_dir, "daemonset.yaml"),
        "config_env":      has_anywhere(app_dir, "config.env"),
        "secret_env":      has_anywhere(app_dir, "secret.env"),
    }


# ---------- discovery ----------

def is_app_dir(d: Path) -> bool:
    """Has kustomization.yaml AND a top-level workload yaml in this dir."""
    if not (d / "kustomization.yaml").is_file():
        return False
    for f in d.glob("*.yaml"):
        if f.name == "kustomization.yaml":
            continue
        if any(x.get("kind") in WORKLOADS for x in load_docs(f)):
            return True
    return False


def find_app_dirs(root: Path) -> list[Path]:
    out = []
    for d in root.rglob("*"):
        if not d.is_dir():
            continue
        parts = d.relative_to(root).parts
        if any(p in SKIP_PARTS or p.startswith("template") for p in parts):
            continue
        if is_app_dir(d):
            out.append(d)
    return sorted(out)


def load_all_docs(app_dir: Path) -> list[dict]:
    docs = []
    for f in sorted(app_dir.rglob("*.yaml")):
        if f.name == "kustomization.yaml":
            continue
        docs.extend(load_docs(f))
    return docs


def zone_group_name(app_dir: Path) -> tuple[str, str, str]:
    rel = app_dir.relative_to(BASE).parts
    zone = rel[0]
    name = rel[-1]
    group = "/".join(rel[1:-1]) if len(rel) > 2 else ""
    return zone, group, name


# ---------- manifest ----------

def scan() -> dict:
    apps: dict[str, dict] = {}
    for app_dir in find_app_dirs(BASE):
        zone, group, name = zone_group_name(app_dir)
        key = "/".join(p for p in (zone, group, name) if p)
        docs = load_all_docs(app_dir)
        apps[key] = {
            "zone":    zone,
            "group":   group,
            "name":    name,
            "path":    str(app_dir.relative_to(REPO)),
            "options": detect_options(app_dir, docs),
        }
    return {
        "version":      1,
        "generated_at": datetime.now(timezone.utc).isoformat(timespec="seconds"),
        "base":         str(BASE.relative_to(REPO)),
        "apps":         apps,
    }


def load_manifest(p: Path) -> dict:
    if not p.exists():
        sys.exit(f"manifest not found: {p}  (run `scan` first)")
    return json.loads(p.read_text())


def save_manifest(p: Path, m: dict) -> None:
    p.write_text(json.dumps(m, indent=2, sort_keys=True) + "\n")


# ---------- commands ----------

def cmd_scan(args) -> None:
    m = scan()
    save_manifest(args.out, m)
    print(f"scanned {len(m['apps'])} apps -> {args.out}")
    roll: dict[str, int] = {}
    for a in m["apps"].values():
        for k, v in a["options"].items():
            if v:
                roll[k] = roll.get(k, 0) + 1
    print("option totals:")
    for k in sorted(roll):
        print(f"  {k:18s} {roll[k]:3d}")


def cmd_list(args) -> None:
    m = load_manifest(args.manifest)
    for key, a in sorted(m["apps"].items()):
        on = [k for k, v in a["options"].items() if v]
        print(f"{key:45s}  {', '.join(on)}")


def cmd_show(args) -> None:
    m = load_manifest(args.manifest)
    if args.key not in m["apps"]:
        sys.exit(f"unknown app: {args.key}")
    print(json.dumps(m["apps"][args.key], indent=2))


def cmd_set(args) -> None:
    m = load_manifest(args.manifest)
    if args.key not in m["apps"]:
        sys.exit(f"unknown app: {args.key}")
    opts = m["apps"][args.key]["options"]
    if args.option not in opts:
        sys.exit(f"unknown option: {args.option}  "
                 f"(valid: {', '.join(sorted(opts))})")
    opts[args.option] = args.value.lower() in ("1", "true", "yes", "on")
    save_manifest(args.manifest, m)
    print(f"{args.key}: {args.option} = {opts[args.option]}")


def main() -> None:
    ap = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--manifest", type=Path, default=DEFAULT_MANIFEST)
    sub = ap.add_subparsers(dest="cmd", required=True)

    p = sub.add_parser("scan")
    p.add_argument("--out", type=Path, default=DEFAULT_MANIFEST)
    p.set_defaults(func=cmd_scan)

    p = sub.add_parser("list")
    p.set_defaults(func=cmd_list)

    p = sub.add_parser("show")
    p.add_argument("key")
    p.set_defaults(func=cmd_show)

    p = sub.add_parser("set")
    p.add_argument("key")
    p.add_argument("option")
    p.add_argument("value")
    p.set_defaults(func=cmd_set)

    args = ap.parse_args()
    args.func(args)


if __name__ == "__main__":
    main()