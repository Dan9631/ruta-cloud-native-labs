#!/bin/bash
# whoami escalado a 5 replicas listas y las 5 IPs en el EndpointSlice del Service.
ns=lab-06
estado=$(kubectl get deploy whoami -n $ns -o jsonpath='{.spec.replicas}/{.status.readyReplicas}' 2>/dev/null)
[ "$estado" = "5/5" ] || { echo "Falta escalar whoami a 5 replicas listas (ahora: '$estado')"; exit 1; }
ips=$(kubectl get endpointslices -n $ns -l kubernetes.io/service-name=whoami -o jsonpath='{.items[*].endpoints[*].addresses[0]}' 2>/dev/null | wc -w)
[ "$ips" -eq 5 ] || { echo "El EndpointSlice de whoami todavia no tiene 5 IPs (ahora: $ips). Espera unos segundos y repite"; exit 1; }
