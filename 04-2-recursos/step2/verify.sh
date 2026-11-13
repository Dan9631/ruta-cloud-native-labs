#!/bin/bash
# LimitRange aplicado a sin-recursos, ResourceQuota de 6 Pods y relleno parado en 5 de 8.
ns=lab-04
falta() { echo "$1"; exit 1; }
kubectl get limitrange limites-lab -n $ns >/dev/null 2>&1 || falta "Falta el LimitRange limites-lab: aplica 11-limitrange.yaml"
req=$(kubectl get pod sin-recursos -n $ns -o jsonpath='{.spec.containers[0].resources.requests.cpu}/{.status.qosClass}' 2>/dev/null)
[ "$req" = "25m/Burstable" ] || falta "Falta el Pod sin-recursos con los valores por defecto del LimitRange (ahora: '$req')"
[ "$(kubectl get resourcequota cuota-lab -n $ns -o jsonpath='{.spec.hard.pods}' 2>/dev/null)" = "6" ] \
  || falta "Falta la ResourceQuota cuota-lab con pods=6: aplica 12-quota.yaml"
estado=$(kubectl get deploy relleno -n $ns -o jsonpath='{.spec.replicas}/{.status.readyReplicas}' 2>/dev/null)
[ "$estado" = "8/5" ] || falta "Falta el Deployment relleno con 8 replicas pedidas y 5 listas (ahora: '$estado')"
