#!/bin/bash
# Service whoami-nodeport de tipo NodePort en el 30080 y que responda un Pod whoami por la IP del nodo.
ns=lab-06
np=$(kubectl get svc whoami-nodeport -n $ns -o jsonpath='{.spec.type}/{.spec.ports[0].nodePort}' 2>/dev/null)
[ "$np" = "NodePort/30080" ] || { echo "Falta el Service whoami-nodeport de tipo NodePort en el puerto 30080 en $ns (ahora: '$np')"; exit 1; }
ip=$(kubectl get node controlplane -o jsonpath='{.status.addresses[?(@.type=="InternalIP")].address}')
curl -s --max-time 5 "http://$ip:30080" | grep -q 'Hostname: whoami-' \
  || { echo "http://$ip:30080 no responde con un Pod whoami todavia"; exit 1; }
