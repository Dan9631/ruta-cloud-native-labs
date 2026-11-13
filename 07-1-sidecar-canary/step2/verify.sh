#!/bin/bash
# El sidecar log-tail muestra en sus logs la peticion a /no-existe que se hizo contra nginx.
kubectl get pod web-con-sidecar -n lab-07 >/dev/null 2>&1 || { echo "No existe el Pod web-con-sidecar en lab-07: vuelve al paso 1"; exit 1; }
kubectl logs web-con-sidecar -n lab-07 -c log-tail 2>/dev/null | grep -q 'GET /no-existe' \
  || { echo "Los logs de log-tail todavia no muestran la peticion a /no-existe: ejecuta el kubectl exec del paso"; exit 1; }
