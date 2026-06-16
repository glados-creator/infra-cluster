# system
# main
traefik LB static ip 192.168.1.1 LB 80 443 IP 2280 2282
technitium LB static ip 192.168.1.2 LB 53 853 8053 IP 2283 2284
(kubectl port-forward --address 0.0.0.0 svc/technitium-service 2283:2283)
# public
glance IP 9900 TODO CONF
gatus IP 9901 TODO CONF
# dmz
glance IP 6600 TODO CONF
gatus IP 6601 TODO CONF
# private
glance IP 4400 TODO CONF
gatus IP 4401 TODO CONF
dozzle IP 4415