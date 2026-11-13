#!/bin/bash
# El Pod app-manual se borro, y un PVC claim-manual NUEVO (creado despues que el PV) esta Bound a lab-08-pv-manual.
kubectl get pod app-manual -n lab-08 >/dev/null 2>&1 && { echo "Falta borrar el Pod app-manual"; exit 1; }
estado=$(kubectl get pvc claim-manual -n lab-08 -o jsonpath='{.status.phase}/{.spec.volumeName}' 2>/dev/null)
[ "$estado" = "Bound/lab-08-pv-manual" ] || { echo "El PVC claim-manual deberia estar Bound a lab-08-pv-manual: quita el claimRef del PV (ahora: '$estado')"; exit 1; }
pv=$(date -d "$(kubectl get pv lab-08-pv-manual -o jsonpath='{.metadata.creationTimestamp}')" +%s)
pvc=$(date -d "$(kubectl get pvc claim-manual -n lab-08 -o jsonpath='{.metadata.creationTimestamp}')" +%s)
[ $((pvc - pv)) -ge 10 ] || { echo "Falta borrar el PVC claim-manual, crearlo de nuevo y volver a enlazarlo"; exit 1; }
