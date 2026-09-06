# Local HTTPS for the k3s homelab (no public domain)

Approach: skip Let's Encrypt / DNS-01 entirely (Technitium can't do that
natively anyway). Instead cert-manager runs its own private CA, issues one
wildcard cert from it, and Traefik uses that cert for every host. Calico
and Multus don't need any changes — they operate below the TLS layer, this
is all just cert-manager + Traefik CRDs.

## Layout
```
https-stack/
├── cert-manager/private-ca/     # one-time: creates the root CA + issuer
│   ├── selfsigned-issuer.yaml
│   ├── ca-certificate.yaml
│   ├── ca-issuer.yaml
│   └── kustomization.yaml
├── traefik/wildcard-tls/        # the actual *.k3s.home cert + Traefik wiring
│   ├── certificate.yaml
│   ├── tlsstore.yaml
│   └── kustomization.yaml
└── technitium/README.md         # DNS records, not a manifest
```

Drop `cert-manager/private-ca` and `traefik/wildcard-tls` into your
`infra-cluster-ct` repo's `base/` tree (or reference them as bases from
existing kustomizations) alongside your other cert-manager/Traefik apps.

## Before you apply
- **Pick your domain.** Every file uses `k3s.home` as a placeholder — replace
  it everywhere (`grep -rl k3s.home .`) with whatever local TLD you want.
- **Confirm Traefik's namespace.** `certificate.yaml` and `tlsstore.yaml`
  assume a `traefik` namespace; if you're on k3s's bundled Traefik, that's
  `kube-system` instead — edit both files' `namespace:` and the
  kustomization's `namespace:` field to match.
- **cert-manager must already be installed and running** (CRDs + controller).

## Apply order
```bash
kubectl apply -k cert-manager/private-ca/
kubectl -n cert-manager wait --for=condition=Ready certificate/k3s-homelab-ca --timeout=60s

kubectl apply -k traefik/wildcard-tls/
kubectl -n traefik wait --for=condition=Ready certificate/traefik-wildcard --timeout=60s
```
Then follow `technitium/README.md` to point `*.k3s.home` at Traefik.

## Result
Any Ingress/IngressRoute host under `*.k3s.home` gets HTTPS automatically
via the TLSStore default — you don't need a `tls.secretName` on each one.
Browsers will show an untrusted-cert warning since it's your own CA, not a
public one; that's expected and the README in `technitium/` has the
one-time optional fix if you ever want it gone.
