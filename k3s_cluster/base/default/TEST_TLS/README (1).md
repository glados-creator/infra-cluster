# Technitium: point *.k3s.home at Traefik

Technitium isn't in the TLS path here at all — you're not using DNS-01
challenges, so Technitium's only job is resolving names to Traefik's IP.

1. Find Traefik's reachable IP:
   - k3s built-in Traefik (ServiceLB): `kubectl -n kube-system get svc traefik`
     — use the `EXTERNAL-IP`.
   - MetalLB / other LoadBalancer: same command, whatever namespace Traefik's
     Service lives in.
   - Bare NodePort: any node's IP works.

2. In the Technitium web UI (or API), create/open the zone for your local
   domain (e.g. `k3s.home`) and add:
   - `A  k3s.home          -> <traefik-ip>`
   - `A  *.k3s.home        -> <traefik-ip>`

   Via the API instead of the UI:
   ```bash
   curl "http://<technitium-host>:5380/api/zones/records/add?token=<API_TOKEN>&domain=*.k3s.home&type=A&ipAddress=<traefik-ip>"
   curl "http://<technitium-host>:5380/api/zones/records/add?token=<API_TOKEN>&domain=k3s.home&type=A&ipAddress=<traefik-ip>"
   ```

3. Point your clients/router at Technitium as their DNS server (you've
   presumably already done this). Any `<app>.k3s.home` now resolves to
   Traefik, which terminates TLS with the wildcard cert.

## Optional: stop the browser warning
Since it's self-signed-by-your-own-CA rather than public, browsers will
warn once. If you want that gone, export the CA cert and trust it locally:
```bash
kubectl -n cert-manager get secret k3s-homelab-ca-secret -o jsonpath='{.data.ca\.crt}' | base64 -d > k3s-homelab-ca.crt
```
Then import `k3s-homelab-ca.crt` into your OS/browser trust store on
whichever machines you care about. Entirely optional — you said you don't
mind the warning.
