"""Source of truth. Edit this, run main.py, get folders + yaml."""
from model import (
    App, Container, Port, Config, Secret, Mount, Ingress, Options,
    ServiceAccount, PolicyRule, Folder,
)


# ---------- SA presets ----------

def sa_plain() -> ServiceAccount:
    return ServiceAccount(name="sa")


def sa_reader() -> ServiceAccount:
    return ServiceAccount(name="sa", rules=[
        PolicyRule(verbs=["get", "list", "watch"],
                   resources=["pods", "services", "endpoints",
                              "configmaps", "nodes", "namespaces"]),
    ])


def sa_pod_logs() -> ServiceAccount:
    return ServiceAccount(name="sa", rules=[
        PolicyRule(verbs=["get", "list", "watch"],
                   resources=["pods", "pods/log"]),
        PolicyRule(verbs=["create"], resources=["pods/exec"]),
    ])


# ---------- app factories ----------

def web(name: str, image: str, *, port: int = 8080,
        storage: str = "none", linkerd: bool = True,
        host: str | None = None, auth: str | None = None,
        sa: ServiceAccount | None = None, gpu: bool = False,
        size: str | None = None) -> App:
    mounts = [Mount("data", "/data", size=size)] if size else []
    return App(
        name=name,
        containers=[Container(
            name="app", image=image,
            ports=[Port(port)],
            mounts=mounts,
        )],
        options=Options(storage=storage, linkerd=linkerd, gpu=gpu),
        ingress=Ingress(host=host or f"{name}.lan", auth=auth),
        service_account=sa,
    )


def arr(name: str) -> App:
    """The *arr stack — same shape for a dozen apps."""
    return App(
        name=name,
        containers=[Container(
            name="app",
            image=f"lscr.io/linuxserver/{name}:latest",
            ports=[Port(8080)],
        )],
        ingress=Ingress(host=f"{name}.lan", auth="auth-authentik"),
        # deliberately no SA, no PV — matches the scan
    )


# ---------- the tree ----------

tree = Folder("k3s_cluster/base", [

    Folder("default", [
        App(
            name="node-exporter",
            kind="DaemonSet",
            containers=[Container(name="node-exporter",
                                  image="prom/node-exporter:latest",
                                  ports=[Port(9100, "metrics")])],
        ),
        App(
            name="traefik",
            containers=[Container(name="traefik",
                                  image="traefik:v3",
                                  ports=[Port(80), Port(443)])],
            options=Options(linkerd=True),
            service_account=ServiceAccount(name="sa", rules=[
                PolicyRule(verbs=["get", "list", "watch"],
                           api_groups=[""], resources=["services", "endpoints"]),
            ]),
        ),
        App(
            name="dozzle",
            containers=[Container(name="dozzle",
                                  image="amir20/dozzle:latest",
                                  ports=[Port(8080)])],
            options=Options(storage="cephfs", linkerd=True),
            service_account=sa_pod_logs(),
            ingress=Ingress(host="dozzle.lan"),
        ),
    ]),

    Folder("dmz", [
        Folder("media", [
            arr("jellyfin"), arr("sonarr"), arr("radarr"),
            arr("lidarr"), arr("bazarr"), arr("prowlarr"),
            arr("autobrr"), arr("kapowarr"), arr("profilarr"),
            arr("qbittorrent"), arr("tdarr"), arr("unpackerr"),
            arr("jellyseerr"),
        ]),
        Folder("alternative-frontends", [
            web("invidious", "quay.io/invidious/invidious:latest",
                storage="cephfs", sa=sa_plain(), size="10Gi"),
            web("piped", "1337kavin/piped:latest",
                storage="cephfs", sa=sa_plain(), size="10Gi"),
            web("searxng", "searxng/searxng:latest",
                storage="cephfs", sa=sa_plain(), size="5Gi"),
        ]),
        Folder("cloud", [
            web("immich", "ghcr.io/immich-app/immich-server:latest",
                storage="cephfs", sa=sa_plain(), size="100Gi"),
        ]),
        Folder("oss", [
            web("forgejo", "codeberg.org/forgejo/forgejo:latest",
                port=3000, storage="cephfs", sa=sa_plain(), size="20Gi"),
        ]),
    ]),

    Folder("private", [
        Folder("code", [
            web("ollama", "ollama/ollama:latest", port=11434,
                storage="cephfs", sa=sa_plain(), gpu=True, size="50Gi",
                auth="auth-authentik"),
            web("comfyui", "comfyui/comfyui:latest",
                storage="cephfs", sa=sa_plain(), gpu=True, size="50Gi",
                auth="auth-authentik"),
            web("n8n", "n8nio/n8n:latest",
                storage="cephfs", sa=sa_plain(), size="5Gi",
                auth="auth-authentik"),
            web("vscodium", "lscr.io/linuxserver/vscodium:latest",
                storage="cephfs", sa=sa_plain(), size="10Gi",
                auth="auth-authentik"),
        ]),
        Folder("monitor", [
            web("grafana", "grafana/grafana:latest", port=3000,
                storage="cephfs", sa=sa_plain(), size="10Gi"),
            web("prometheus", "prom/prometheus:latest", port=9090,
                storage="cephfs", sa=sa_plain(), size="50Gi"),
            App(
                name="headlamp",
                containers=[Container(name="headlamp",
                                      image="ghcr.io/headlamp-k8s/headlamp:latest",
                                      ports=[Port(4466)])],
                options=Options(storage="cephfs", linkerd=True),
                service_account=ServiceAccount(name="sa", rules=[
                    *sa_reader().rules,
                    *sa_pod_logs().rules,
                ]),
                ingress=Ingress(host="headlamp.lan"),
            ),
        ]),
    ]),

    Folder("public", [
        web("gatus", "twinproduction/gatus:latest",
            storage="cephfs", sa=sa_plain(), size="1Gi",
            linkerd=False, auth=None),
        web("glance", "glanceapp/glance:latest",
            storage="none", sa=sa_plain(), linkerd=False),
    ]),
])