#!/bin/bash
# db-0 se recreo (dos arranques en su volumen), el StatefulSet tiene 1 replica y el PVC datos-db-1 se conserva.
arranques=$(kubectl exec db-0 -n lab-08 -- cat /var/lib/db/arranques.txt 2>/dev/null | grep -c 'db-0 arranco')
[ "${arranques:-0}" -ge 2 ] || { echo "Falta borrar el Pod db-0 y esperar a que vuelva: su volumen deberia tener 2 arranques (ahora: ${arranques:-0})"; exit 1; }
estado=$(kubectl get sts db -n lab-08 -o jsonpath='{.spec.replicas}' 2>/dev/null)
[ "$estado" = "1" ] || { echo "Falta reducir el StatefulSet db a 1 replica (ahora: '$estado')"; exit 1; }
kubectl get pod db-1 -n lab-08 >/dev/null 2>&1 && { echo "El Pod db-1 todavia existe: espera unos segundos"; exit 1; }
kubectl get pvc datos-db-1 -n lab-08 >/dev/null 2>&1 || { echo "El PVC datos-db-1 deberia seguir existiendo"; exit 1; }
