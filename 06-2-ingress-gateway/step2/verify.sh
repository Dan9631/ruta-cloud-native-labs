#!/bin/bash
# HTTPRoute whoami aceptada por el Gateway y que Traefik sirva /lab06/gateway con un Pod whoami.
ns=lab-06
kubectl get httproute whoami -n $ns >/dev/null 2>&1 || { echo "Falta la HTTPRoute whoami en $ns"; exit 1; }
cond=$(kubectl get httproute whoami -n $ns -o jsonpath='{range .status.parents[0].conditions[*]}{.type}={.status} {end}')
echo "$cond" | grep -q 'Accepted=True' || { echo "La HTTPRoute whoami todavia no esta aceptada por el Gateway (ahora: '$cond')"; exit 1; }
ip=$(kubectl get node controlplane -o jsonpath='{.status.addresses[?(@.type=="InternalIP")].address}')
curl -s --max-time 5 "http://$ip:30800/lab06/gateway" | grep -q 'Hostname: whoami-' \
  || { echo "http://$ip:30800/lab06/gateway todavia no responde con un Pod whoami. Espera unos segundos y repite"; exit 1; }
