"""Pure data. No I/O, no rendering. This is the source of truth."""
from __future__ import annotations
from dataclasses import dataclass, field
from typing import Literal

Storage = Literal["none", "cephfs", "nfs"]
Proto   = Literal["TCP", "UDP"]
Kind    = Literal["Deployment", "DaemonSet", "StatefulSet"]


# ---------- primitives ----------

@dataclass
class Port:
    number: int
    name:   str = "http"
    proto:  Proto = "TCP"
    expose: bool = True          # also goes into service.yaml


@dataclass
class Config:
    key:   str
    value: str


@dataclass
class Secret:
    key:   str
    value: str


@dataclass
class Mount:
    name:  str                   # logical name -> volume name + pvc-<name>
    at:    str                   # container mountPath
    size:  str | None = None     # None -> emptyDir
    ro:    bool = False


@dataclass
class Container:
    name:   str
    image:  str
    ports:  list[Port]   = field(default_factory=list)
    config: list[Config] = field(default_factory=list)
    secret: list[Secret] = field(default_factory=list)
    mounts: list[Mount]  = field(default_factory=list)
    args:   list[str]    = field(default_factory=list)
    cmd:    list[str]    = field(default_factory=list)
    cpu:    str | None   = None
    mem:    str | None   = None


@dataclass
class Ingress:
    host: str
    port: str = "http"           # Port.name
    auth: str | None = None      # middleware, e.g. "auth-authentik"
    tls:  bool = True


# ---------- RBAC ----------

@dataclass
class PolicyRule:
    verbs:              list[str]
    api_groups:         list[str] = field(default_factory=lambda: [""])
    resources:          list[str] = field(default_factory=list)
    resource_names:     list[str] = field(default_factory=list)
    non_resource_urls:  list[str] = field(default_factory=list)


@dataclass
class ServiceAccount:
    name:              str = "sa"
    rules:             list[PolicyRule] = field(default_factory=list)
    cluster_role_name: str | None = None    # default: f"{app}-role"
    binding_name:      str | None = None    # default: f"{app}-rb"

    @property
    def needs_cluster_role(self) -> bool:
        return bool(self.rules)


# ---------- app ----------

@dataclass
class Options:
    storage: Storage = "none"
    linkerd: bool = False
    gpu:     bool = False


@dataclass
class App:
    name:            str
    containers:      list[Container]
    kind:            Kind = "Deployment"
    replicas:        int = 1
    options:         Options = field(default_factory=Options)
    ingress:         Ingress | None = None
    namespace:       str | None = None       # None -> overlay decides
    tolerations:     list[dict] = field(default_factory=list)
    service_account: ServiceAccount | None = None


# ---------- tree ----------

@dataclass
class Folder:
    name:     str
    children: list["App | Folder"] = field(default_factory=list)

    def app(self, **kw) -> App:
        a = App(**kw)
        self.children.append(a)
        return a

    def folder(self, name: str) -> "Folder":
        for c in self.children:
            if isinstance(c, Folder) and c.name == name:
                return c
        f = Folder(name)
        self.children.append(f)
        return f


Node = App | Folder