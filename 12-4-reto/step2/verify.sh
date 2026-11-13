#!/bin/bash
# Reto del modulo 12, parte B (Helm): portado de labs/12-application-delivery-gitops/check.ps1.
ns=lab-12
falta() { echo "FALTA: $1"; exit 1; }

ultima=$(helm history tienda -n $ns --max 1 -o json 2>/dev/null)
[ -n "$ultima" ] || falta "no existe el release 'tienda' en $ns"
echo "$ultima" | grep -q '"status":"deployed"' && echo "$ultima" | grep -q '"description":"Rollback to 1"' \
  || falta "la ultima revision de 'tienda' debe estar desplegada y ser 'Rollback to 1'"
rev=$(echo "$ultima" | grep -oE '"revision":[0-9]+' | grep -oE '[0-9]+')
[ "${rev:-0}" -ge 3 ] || falta "el historial de 'tienda' debe tener al menos 3 revisiones (install, upgrade y rollback)"

[ "$(kubectl get deploy tienda -n $ns -o jsonpath='{.spec.replicas}' 2>/dev/null)" = "1" ] \
  || falta "tras el rollback, el Deployment 'tienda' debe volver a 1 replica"
kubectl get cm tienda-html -n $ns -o jsonpath='{.data.index\.html}' 2>/dev/null | grep -q 'Tienda v1' \
  || falta "tras el rollback, 'tienda' debe mostrar el mensaje 'Tienda v1'"

echo "Reto superado"
