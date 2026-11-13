#!/bin/bash
# El Pod consume-config esta listo y recibe la configuracion como variable y como archivo.
listo=$(kubectl get pod consume-config -n lab-03 -o jsonpath='{.status.conditions[?(@.type=="Ready")].status}' 2>/dev/null)
[ "$listo" = "True" ] || { echo "El Pod consume-config todavia no esta Ready en lab-03"; exit 1; }
color=$(kubectl exec consume-config -n lab-03 -- sh -c 'echo $COLOR' 2>/dev/null)
[ "$color" = "azul" ] || { echo "La variable COLOR del Pod deberia valer azul (ahora: '$color')"; exit 1; }
kubectl exec consume-config -n lab-03 -- test -f /etc/app/app.properties 2>/dev/null || { echo "Falta el archivo /etc/app/app.properties dentro del Pod"; exit 1; }
