#!/bin/bash
# PV estatico lab-08-pv-manual enlazado a claim-manual y el Pod app-manual escribiendo en el en node01.
estado=$(kubectl get pv lab-08-pv-manual -o jsonpath='{.status.phase}/{.spec.claimRef.name}/{.spec.persistentVolumeReclaimPolicy}' 2>/dev/null)
[ "$estado" = "Bound/claim-manual/Retain" ] || { echo "El PV lab-08-pv-manual deberia estar Bound a claim-manual con Retain: aplica /root/lab/04-pv-estatico.yaml (ahora: '$estado')"; exit 1; }
pod=$(kubectl get pod app-manual -n lab-08 -o jsonpath='{.status.conditions[?(@.type=="Ready")].status}/{.spec.nodeName}' 2>/dev/null)
[ "$pod" = "True/node01" ] || { echo "Falta el Pod app-manual listo en node01: aplica /root/lab/05-pod-pv-manual.yaml (ahora: '$pod')"; exit 1; }
kubectl exec app-manual -n lab-08 -- cat /mnt/disco/saludo.txt 2>/dev/null | grep -q 'hola desde app-manual' \
  || { echo "Falta /mnt/disco/saludo.txt dentro de app-manual"; exit 1; }
