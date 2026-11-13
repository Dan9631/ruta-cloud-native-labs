#!/bin/bash
# frontend actualizado a 1.28, con las 3 replicas nuevas listas y al menos 2 revisiones.
estado=$(kubectl get deploy frontend -n lab-03 -o jsonpath='{.spec.template.spec.containers[0].image}/{.status.updatedReplicas}/{.status.readyReplicas}' 2>/dev/null)
[ "$estado" = "nginx:1.28-alpine/3/3" ] || { echo "frontend deberia usar nginx:1.28-alpine con 3 replicas actualizadas y listas (ahora: '$estado')"; exit 1; }
rev=$(kubectl get deploy frontend -n lab-03 -o jsonpath='{.metadata.annotations.deployment\.kubernetes\.io/revision}' 2>/dev/null)
[ "${rev:-0}" -ge 2 ] || { echo "El historial de frontend deberia tener al menos 2 revisiones (ahora: '$rev')"; exit 1; }
