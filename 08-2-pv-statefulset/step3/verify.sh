#!/bin/bash
# StatefulSet db con 2 replicas listas y un PVC Bound por replica (datos-db-0 y datos-db-1).
listas=$(kubectl get sts db -n lab-08 -o jsonpath='{.status.readyReplicas}' 2>/dev/null)
[ "$listas" = "2" ] || { echo "El StatefulSet db deberia tener 2 replicas listas: aplica /root/lab/06-statefulset.yaml (ahora: '$listas')"; exit 1; }
for pvc in datos-db-0 datos-db-1; do
  fase=$(kubectl get pvc $pvc -n lab-08 -o jsonpath='{.status.phase}' 2>/dev/null)
  [ "$fase" = "Bound" ] || { echo "El PVC $pvc deberia estar Bound (ahora: '$fase')"; exit 1; }
done
