#!/bin/bash
# La release prometheus esta desplegada en lab-11 con el chart 29.37.2 y sus tres piezas estan listas.
ns=lab-11
falta() { echo "$1"; exit 1; }

helm status prometheus -n $ns 2>/dev/null | grep -q '^STATUS: deployed' \
  || falta "Falta la release de Helm 'prometheus' en $ns con STATUS deployed"
helm list -n $ns 2>/dev/null | grep -E '^prometheus\s' | grep -q 'prometheus-29.37.2' \
  || falta "La release 'prometheus' debe usar el chart prometheus-29.37.2 (--version 29.37.2)"

[ "$(kubectl get deploy prometheus-server -n $ns -o jsonpath='{.status.readyReplicas}' 2>/dev/null)" = "1" ] \
  || falta "El Deployment prometheus-server todavia no tiene su Pod listo"
[ "$(kubectl get deploy prometheus-kube-state-metrics -n $ns -o jsonpath='{.status.readyReplicas}' 2>/dev/null)" = "1" ] \
  || falta "El Deployment prometheus-kube-state-metrics todavia no tiene su Pod listo"

ds=$(kubectl get ds prometheus-prometheus-node-exporter -n $ns -o jsonpath='{.status.desiredNumberScheduled}/{.status.numberReady}' 2>/dev/null)
[ "$ds" = "2/2" ] || falta "El DaemonSet de node-exporter debe tener 2 Pods listos, uno por nodo (ahora deseados/listos: '$ds')"
