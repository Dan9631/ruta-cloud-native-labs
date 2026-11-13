#!/bin/bash
# El Pod proyectado esta listo y en /etc/app ve las tres fuentes del volumen projected.
listo=$(kubectl get pod proyectado -n lab-08 -o jsonpath='{.status.conditions[?(@.type=="Ready")].status}' 2>/dev/null)
[ "$listo" = "True" ] || { echo "Falta el Pod proyectado listo en lab-08: aplica /root/lab/07-projected.yaml (ahora: '$listo')"; exit 1; }
archivos=$(kubectl exec proyectado -n lab-08 -- ls /etc/app 2>/dev/null | tr '\n' ' ')
[ "$archivos" = "app.properties etiquetas token " ] || { echo "En /etc/app deberian estar app.properties, etiquetas y token (ahora: '$archivos')"; exit 1; }
