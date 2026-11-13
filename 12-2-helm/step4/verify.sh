#!/bin/bash
# La ultima revision de 'saludo' es un rollback a la 1 (revision >= 3) y el Deployment volvio a v1.
ns=lab-12
ultima=$(helm history saludo -n $ns --max 1 -o json 2>/dev/null)
echo "$ultima" | grep -q '"description":"Rollback to 1"' && echo "$ultima" | grep -q '"status":"deployed"' \
  || { echo "Falta el rollback: la ultima revision de 'saludo' debe ser 'Rollback to 1'"; exit 1; }
rev=$(kubectl get secret -n $ns -l owner=helm,name=saludo,status=deployed -o jsonpath='{.items[0].metadata.labels.version}' 2>/dev/null)
[ "${rev:-0}" -ge 3 ] || { echo "El rollback debe crear una revision nueva (3 o mas); ahora la desplegada es la '${rev:-ninguna}'"; exit 1; }
estado=$(kubectl get deploy saludo -n $ns -o jsonpath='{.spec.replicas}/{.status.readyReplicas}/{.spec.template.spec.containers[0].image}' 2>/dev/null)
[ "$estado" = "1/1/nginx:1.27-alpine" ] || { echo "Tras el rollback, 'saludo' debe tener 1 replica lista con nginx:1.27-alpine (ahora: '$estado')"; exit 1; }
