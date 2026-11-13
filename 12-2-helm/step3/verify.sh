#!/bin/bash
# El release 'saludo' esta en la revision 2 (o posterior) con los values de values-v2.yaml aplicados.
ns=lab-12
rev=$(kubectl get secret -n $ns -l owner=helm,name=saludo,status=deployed -o jsonpath='{.items[0].metadata.labels.version}' 2>/dev/null)
[ "${rev:-0}" -ge 2 ] || { echo "Falta el upgrade: el release 'saludo' sigue en la revision '${rev:-ninguna}'"; exit 1; }
estado=$(kubectl get deploy saludo -n $ns -o jsonpath='{.spec.replicas}/{.status.readyReplicas}/{.spec.template.spec.containers[0].image}' 2>/dev/null)
[ "$estado" = "2/2/nginx:1.28-alpine" ] || { echo "El Deployment 'saludo' debe tener 2 replicas listas con nginx:1.28-alpine (ahora: '$estado')"; exit 1; }
kubectl get cm saludo-html -n $ns -o jsonpath='{.data.index\.html}' 2>/dev/null | grep -q 'Hola desde Helm (v2)' \
  || { echo "El ConfigMap saludo-html debe mostrar el mensaje 'Hola desde Helm (v2)'"; exit 1; }
