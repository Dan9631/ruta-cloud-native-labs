#!/bin/bash
# Static Pod retirado, controlplane sin taint, otro-scheduler Pending sin nodo y critico con prioridad 100000.
ns=lab-04
falta() { echo "$1"; exit 1; }
[ -f /etc/kubernetes/manifests/lab-04-estatico.yaml ] \
  && falta "Borra el archivo /etc/kubernetes/manifests/lab-04-estatico.yaml"
kubectl get node controlplane -o jsonpath='{.spec.taints[*].key}' | grep -qw 'node-role.kubernetes.io/control-plane' \
  && falta "Quita el taint node-role.kubernetes.io/control-plane:NoSchedule de controlplane (con el guion final)"
estado=$(kubectl get pod otro-scheduler -n $ns -o jsonpath='{.spec.schedulerName}/{.status.phase}/{.spec.nodeName}' 2>/dev/null)
[ "$estado" = "mi-scheduler/Pending/" ] || falta "Falta el Pod otro-scheduler en Pending, sin nodo y con schedulerName mi-scheduler (ahora: '$estado')"
[ "$(kubectl get priorityclass lab-04-alta -o jsonpath='{.value}' 2>/dev/null)" = "100000" ] \
  || falta "Falta la PriorityClass lab-04-alta con valor 100000: aplica 17-prioridad.yaml"
estado=$(kubectl get pod critico -n $ns -o jsonpath='{.spec.priority}/{.status.phase}' 2>/dev/null)
[ "$estado" = "100000/Running" ] || falta "Falta el Pod critico Running con prioridad 100000 (ahora: '$estado')"
exit 0
