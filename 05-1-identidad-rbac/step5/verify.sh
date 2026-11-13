#!/bin/bash
# El Pod cliente-api esta Running con la ServiceAccount lector.
estado=$(kubectl get pod cliente-api -n lab-05 -o jsonpath='{.spec.serviceAccountName}/{.status.phase}' 2>/dev/null)
[ "$estado" = "lector/Running" ] || { echo "Falta el Pod cliente-api en lab-05, Running y con serviceAccountName lector (ahora: '$estado')"; exit 1; }
