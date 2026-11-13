#!/bin/bash
# El Pod app-pvc esta listo y el PVC datos esta Bound a un PV dinamico con reclaimPolicy Delete.
listo=$(kubectl get pod app-pvc -n lab-08 -o jsonpath='{.status.conditions[?(@.type=="Ready")].status}' 2>/dev/null)
[ "$listo" = "True" ] || { echo "Falta el Pod app-pvc en lab-08 y listo: aplica /root/lab/03-pod-con-pvc.yaml (ahora: '$listo')"; exit 1; }
fase=$(kubectl get pvc datos -n lab-08 -o jsonpath='{.status.phase}' 2>/dev/null)
[ "$fase" = "Bound" ] || { echo "El PVC datos deberia estar Bound (ahora: '$fase')"; exit 1; }
pv=$(kubectl get pvc datos -n lab-08 -o jsonpath='{.spec.volumeName}')
politica=$(kubectl get pv "$pv" -o jsonpath='{.spec.persistentVolumeReclaimPolicy}' 2>/dev/null)
[ "$politica" = "Delete" ] || { echo "El PV del PVC datos deberia tener reclaimPolicy Delete (ahora: '$politica')"; exit 1; }
