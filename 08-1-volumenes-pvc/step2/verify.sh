#!/bin/bash
# Existe el PVC datos en lab-08: 100Mi, ReadWriteOnce, clase standard.
estado=$(kubectl get pvc datos -n lab-08 -o jsonpath='{.spec.storageClassName}/{.spec.resources.requests.storage}/{.spec.accessModes[0]}' 2>/dev/null)
[ "$estado" = "standard/100Mi/ReadWriteOnce" ] || { echo "Falta el PVC datos en lab-08 (standard, 100Mi, ReadWriteOnce): aplica /root/lab/02-pvc.yaml (ahora: '$estado')"; exit 1; }
