#!/bin/bash
# Ingress whoami en lab-06 y que Traefik sirva /lab06/ingress con un Pod whoami.
ns=lab-06
kubectl get ingress whoami -n $ns >/dev/null 2>&1 || { echo "Falta el Ingress whoami en $ns"; exit 1; }
ip=$(kubectl get node controlplane -o jsonpath='{.status.addresses[?(@.type=="InternalIP")].address}')
curl -s --max-time 5 "http://$ip:30800/lab06/ingress" | grep -q 'Hostname: whoami-' \
  || { echo "http://$ip:30800/lab06/ingress todavia no responde con un Pod whoami. Espera unos segundos y repite"; exit 1; }
