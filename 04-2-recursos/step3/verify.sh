#!/bin/bash
# controlplane con su taint NoSchedule; agente en los 2 nodos y agente-sin-tol solo en 1.
ns=lab-04
falta() { echo "$1"; exit 1; }
kubectl get node controlplane -o jsonpath='{range .spec.taints[*]}{.key}:{.effect}{"\n"}{end}' \
  | grep -qx 'node-role.kubernetes.io/control-plane:NoSchedule' \
  || falta "Falta el taint node-role.kubernetes.io/control-plane:NoSchedule en controlplane"
estado=$(kubectl get ds agente -n $ns -o jsonpath='{.status.desiredNumberScheduled}/{.status.numberReady}' 2>/dev/null)
[ "$estado" = "2/2" ] || falta "El DaemonSet agente deberia tener 2 Pods deseados y listos (ahora: '$estado')"
estado=$(kubectl get ds agente-sin-tol -n $ns -o jsonpath='{.status.desiredNumberScheduled}/{.status.numberReady}' 2>/dev/null)
[ "$estado" = "1/1" ] || falta "El DaemonSet agente-sin-tol deberia tener 1 Pod deseado y listo (ahora: '$estado'). Pon el taint antes de crearlo"
