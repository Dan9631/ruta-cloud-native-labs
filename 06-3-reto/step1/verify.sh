#!/bin/bash
# Reto del modulo 06: tienda publicada con ClusterIP 8080->80, headless, Ingress y HTTPRoute (port de labs/06-networking-services/check.ps1).
ns=lab-06
falta() { echo "FALTA: $1"; exit 1; }

[ "$(kubectl get deploy tienda -n $ns -o jsonpath='{.status.readyReplicas}' 2>/dev/null)" = "2" ] \
  || falta "el Deployment 'tienda' en $ns con 2 replicas listas"

tipo=$(kubectl get svc tienda -n $ns -o jsonpath='{.spec.type}/{.spec.ports[0].port}' 2>/dev/null)
ips=$(kubectl get endpointslices -n $ns -l kubernetes.io/service-name=tienda -o jsonpath='{.items[*].endpoints[*].addresses[0]}' 2>/dev/null | wc -w)
[ "$tipo" = "ClusterIP/8080" ] && [ "$ips" -eq 2 ] \
  || falta "el Service 'tienda' (ClusterIP, puerto 8080 -> 80) con 2 endpoints en su EndpointSlice"

[ "$(kubectl get svc tienda-headless -n $ns -o jsonpath='{.spec.clusterIP}/{.spec.selector.app}' 2>/dev/null)" = "None/tienda" ] \
  || falta "el Service headless 'tienda-headless' (clusterIP: None) que selecciona app=tienda"

ip=$(kubectl get node controlplane -o jsonpath='{.status.addresses[?(@.type=="InternalIP")].address}')
curl -s --max-time 10 "http://$ip:30800/lab06/tienda" | grep -q 'Hostname: tienda-' \
  || falta "un Ingress: http://$ip:30800/lab06/tienda debe responder un Pod tienda-*"

curl -s --max-time 10 "http://$ip:30800/lab06/gw-tienda" | grep -q 'Hostname: tienda-' \
  || falta "una HTTPRoute (Gateway API): http://$ip:30800/lab06/gw-tienda debe responder un Pod tienda-*"

echo "Reto superado"
