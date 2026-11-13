#!/bin/bash
# El Pod nginx existe en lab-03, con sus dos labels, y esta Running.
estado=$(kubectl get pod nginx -n lab-03 -o jsonpath='{.metadata.labels.app}/{.metadata.labels.tier}/{.status.phase}' 2>/dev/null)
[ "$estado" = "nginx/web/Running" ] || { echo "Falta el Pod nginx en lab-03 con app=nginx,tier=web y en Running (ahora: '$estado')"; exit 1; }
