"""Pure data. No I/O, no rendering. This is the source of truth."""
from __future__ import annotations
from dataclasses import dataclass, field
from typing import Literal, Union


# ---------- type aliases ----------

Storage = Literal["none", "cephfs", "nfs"]
Proto   = Literal["TCP", "UDP"]
Kind    = Literal["Deployment", "DaemonSet", "StatefulSet"]


# ---------- mounts ----------

@dataclass
class Config:
    """ConfigMap-backed mount. Also registers into configMapGenerator."""
    name: str
    at:   str
    file: str
    ro:   bool = True


@dataclass
class Volume:
    """PVC / emptyDir / hostPath mount."""
    name:      str
    at:        str
    size:      str | None = None
    storage:   Storage = "cephfs"
    ro:        bool = False
    sub_path:  str | None = None
    host_path: str | None = None


@dataclass
class SecretMount:
    """Secret-backed mount (from secretGenerator)."""
    name:     str
    at:       str
    env_file: str
    ro:       bool = True


Mount = Union[Config, Volume, SecretMount]


# ---------- ports ----------

@dataclass
class Port:
    number:       int
    name:         str = "http"
    proto:        Proto = "TCP"
    expose:       bool = True
    service_port: int | None = None


# ---------- rbac ----------

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
    cluster_role_name: str | None = None
    binding_name:      str | None = None

    @property
    def needs_cluster_role(self) -> bool:
        return bool(self.rules)


# ---------- container ----------

@dataclass
class Container:
    image:  str
    name:   str | None = None
    ports:  list[Port]  = field(default_factory=list)
    mounts: list[Mount] = field(default_factory=list)
    env:    dict[str, str] = field(default_factory=dict)
    args:   list[str] = field(default_factory=list)
    cmd:    list[str] = field(default_factory=list)
    cpu:    str | None = None
    mem:    str | None = None


# ---------- ingress ----------

@dataclass
class Ingress:
    host: str
    port: str = "http"
    auth: str | None = None
    tls:  bool = True


# ---------- options ----------

@dataclass
class Options:
    storage: Storage = "none"
    linkerd: bool = False
    gpu:     bool = False
    service: bool = True
    ingress: bool = True
    hpa:     bool = False
    rbac:    bool = True


# ---------- app ----------

@dataclass
class App:
    name:            str
    containers:      list[Container]
    kind:            Kind = "Deployment"
    replicas:        int = 1
    options:         Options = field(default_factory=Options)
    ingress:         Ingress | None = None
    tolerations:     list[dict] = field(default_factory=list)
    service_account: ServiceAccount | None = None


# ---------- tree ----------

@dataclass
class Folder:
    name:     str
    children: list["App | Folder"] = field(default_factory=list)

    def app(self, **kw) -> "App":
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


@dataclass
class Namespace:
    name:     str
    k8s_name: str | None = None
    children: list["App | Folder"] = field(default_factory=list)

    def __post_init__(self) -> None:
        if self.k8s_name is None:
            self.k8s_name = "default" if self.name == "main" else self.name

    def app(self, **kw) -> "App":
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


@dataclass
class Environment:
    name:       str
    namespaces: list[Namespace] = field(default_factory=list)

    def ns(self, name: str) -> Namespace:
        for n in self.namespaces:
            if n.name == name:
                return n
        n = Namespace(name)
        self.namespaces.append(n)
        return n


@dataclass
class Tree:
    environments: list[Environment] = field(default_factory=list)
    main:         Namespace = field(default_factory=lambda: Namespace("main"))

    def env(self, name: str) -> Environment:
        for e in self.environments:
            if e.name == name:
                return e
        e = Environment(name)
        self.environments.append(e)
        return e


Node = App | Folder