#!/bin/bash
# HTTPRoute canary con pesos 90/10, aceptada por el Gateway y respondiendo a traves de Traefik.
pesos=$(kubectl get httproute canary -n lab-07 -o jsonpath='{range .spec.rules[0].backendRefs[*]}{.name}={.weight} {end}' 2>/dev/null)
[ "$pesos" = "whoami-v1=90 whoami-v2=10 " ] || { echo "La HTTPRoute canary deberia repartir whoami-v1=90 whoami-v2=10 (ahora: '$pesos')"; exit 1; }
aceptada=$(kubectl get httproute canary -n lab-07 -o jsonpath='{.status.parents[0].conditions[?(@.type=="Accepted")].status}' 2>/dev/null)
[ "$aceptada" = "True" ] || { echo "El Gateway traefik-gateway todavia no ha aceptado la HTTPRoute canary (Accepted='$aceptada')"; exit 1; }
ip=$(kubectl get node controlplane -o jsonpath='{.status.addresses[?(@.type=="InternalIP")].address}')
curl -s -m 5 "http://$ip:30080/lab07/canary" | grep -q '^Name: v[12]' \
  || { echo "http://$ip:30080/lab07/canary no devuelve la respuesta de whoami: revisa la ruta y los Services"; exit 1; }
