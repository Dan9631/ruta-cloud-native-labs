#!/bin/bash
# La copia api-debug se borro y la Metrics API responde (kubectl top funciona).
ns=lab-09
if kubectl get pod api-debug -n $ns >/dev/null 2>&1; then
  echo "La copia api-debug sigue existiendo: borrala con kubectl delete pod api-debug -n $ns"; exit 1
fi
kubectl top pods -n $ns >/dev/null 2>&1 || { echo "kubectl top todavia no responde: espera a que metrics-server este listo y repite"; exit 1; }
