#!/bin/bash
# Existe la copia api-debug y no lleva el label app (no la adopta el ReplicaSet ni recibe trafico).
ns=lab-09
kubectl get pod api-debug -n $ns >/dev/null 2>&1 || { echo "Falta el Pod 'api-debug': crea la copia con kubectl debug --copy-to=api-debug"; exit 1; }
app=$(kubectl get pod api-debug -n $ns -o jsonpath='{.metadata.labels.app}' 2>/dev/null)
[ -z "$app" ] || { echo "La copia api-debug no deberia llevar el label app (ahora: app=$app). Creala sin --keep-labels"; exit 1; }
