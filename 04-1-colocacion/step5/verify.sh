#!/bin/bash
# web-sin-tol entero en controlplane; batch (toleration + affinity zona-b) entero en node01; taint ya quitado.
ns=lab-04
falta() { echo "$1"; exit 1; }
nodos_de() { kubectl get pods -n $ns -l app=$1 -o jsonpath='{range .items[*]}{.spec.nodeName}{"\n"}{end}' 2>/dev/null; }

[ "$(kubectl get deploy web-sin-tol -n $ns -o jsonpath='{.status.readyReplicas}' 2>/dev/null)" = "4" ] \
  || falta "Falta el Deployment web-sin-tol con 4 replicas listas"
[ "$(nodos_de web-sin-tol | grep -vcx controlplane)" = "0" ] \
  || falta "Todas las replicas de web-sin-tol deberian estar en controlplane: crealas con el taint puesto en node01"

kubectl get deploy batch -n $ns -o jsonpath='{.spec.template.spec.affinity.nodeAffinity}' 2>/dev/null | grep -q zona-b \
  || falta "El Deployment batch todavia no tiene la node affinity a zona-b: aplica 09-batch-dedicado.yaml"
[ "$(kubectl get deploy batch -n $ns -o jsonpath='{.status.updatedReplicas}/{.status.readyReplicas}' 2>/dev/null)" = "4/4" ] \
  || falta "El Deployment batch deberia tener 4 replicas actualizadas y listas"
[ "$(nodos_de batch | grep -vcx node01)" = "0" ] \
  || falta "Todas las replicas de batch deberian estar en node01 (espera a que terminen las antiguas)"

kubectl get node node01 -o jsonpath='{.spec.taints[*].key}' | grep -qw lab-04-dedicado \
  && falta "Quita el taint lab-04-dedicado de node01 (con el guion final)"
exit 0
