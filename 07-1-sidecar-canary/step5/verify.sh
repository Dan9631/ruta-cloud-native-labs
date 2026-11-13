#!/bin/bash
# HTTPRoute canary actualizada a 50/50 y con las dos versiones respondiendo a traves de Traefik.
pesos=$(kubectl get httproute canary -n lab-07 -o jsonpath='{range .spec.rules[0].backendRefs[*]}{.name}={.weight} {end}' 2>/dev/null)
[ "$pesos" = "whoami-v1=50 whoami-v2=50 " ] || { echo "La HTTPRoute canary deberia repartir whoami-v1=50 whoami-v2=50 (ahora: '$pesos')"; exit 1; }
ip=$(kubectl get node controlplane -o jsonpath='{.status.addresses[?(@.type=="InternalIP")].address}')
vistos=$(for i in 1 2 3 4 5 6 7 8 9 10; do curl -s -m 5 "http://$ip:30080/lab07/canary" | grep '^Name:'; done | sort -u | tr '\n' ' ')
[ "$vistos" = "Name: v1 Name: v2 " ] || { echo "Con 50/50 deberian responder v1 y v2 a traves del Gateway (en 10 peticiones se vio: '$vistos')"; exit 1; }
