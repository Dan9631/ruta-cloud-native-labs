#!/bin/bash
# El Pod app-pvc se ha recreado y lee /data/pedidos.txt, escrito ANTES de crear el Pod actual.
listo=$(kubectl get pod app-pvc -n lab-08 -o jsonpath='{.status.conditions[?(@.type=="Ready")].status}' 2>/dev/null)
[ "$listo" = "True" ] || { echo "Falta el Pod app-pvc en lab-08 y listo (ahora: '$listo')"; exit 1; }
kubectl exec app-pvc -n lab-08 -- cat /data/pedidos.txt 2>/dev/null | grep -q 'pedido 1001' \
  || { echo "Falta /data/pedidos.txt con 'pedido 1001' dentro de app-pvc"; exit 1; }
archivo=$(kubectl exec app-pvc -n lab-08 -- stat -c %Y /data/pedidos.txt 2>/dev/null)
creado=$(date -d "$(kubectl get pod app-pvc -n lab-08 -o jsonpath='{.metadata.creationTimestamp}')" +%s 2>/dev/null)
[ -n "$archivo" ] && [ -n "$creado" ] && [ "$archivo" -lt "$creado" ] \
  || { echo "Falta borrar el Pod app-pvc y crearlo de nuevo: el archivo debe ser anterior al Pod que lo lee"; exit 1; }
