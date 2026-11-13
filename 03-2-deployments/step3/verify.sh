#!/bin/bash
# Tras el rollback: frontend otra vez en 1.28 con 3 replicas listas, y en el historial queda la version rota.
estado=$(kubectl get deploy frontend -n lab-03 -o jsonpath='{.spec.template.spec.containers[0].image}/{.status.updatedReplicas}/{.status.readyReplicas}' 2>/dev/null)
[ "$estado" = "nginx:1.28-alpine/3/3" ] || { echo "Tras el rollback, frontend deberia usar nginx:1.28-alpine con 3 replicas listas (ahora: '$estado')"; exit 1; }
kubectl get rs -n lab-03 -l app=frontend -o jsonpath='{range .items[*]}{.spec.template.spec.containers[0].image}{"\n"}{end}' 2>/dev/null | grep -qx 'nginx:9.9-noexiste' \
  || { echo "No hay rastro de la actualizacion rota: ejecuta primero el set image con nginx:9.9-noexiste"; exit 1; }
rev=$(kubectl get deploy frontend -n lab-03 -o jsonpath='{.metadata.annotations.deployment\.kubernetes\.io/revision}' 2>/dev/null)
[ "${rev:-0}" -ge 4 ] || { echo "Se esperaba la revision 4 o posterior tras el rollback (ahora: '$rev')"; exit 1; }
