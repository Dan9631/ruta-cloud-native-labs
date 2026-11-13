#!/bin/bash
# El release 'saludo' esta desplegado en lab-12 y su Deployment tiene 1 replica lista.
# Helm guarda cada revision en un Secret con los labels owner=helm, name, status y version.
ns=lab-12
rev=$(kubectl get secret -n $ns -l owner=helm,name=saludo,status=deployed -o jsonpath='{.items[0].metadata.labels.version}' 2>/dev/null)
[ -n "$rev" ] || { echo "Falta el release 'saludo' desplegado en lab-12: helm install saludo /root/lab/helm/saludo -n lab-12"; exit 1; }
listo=$(kubectl get deploy saludo -n $ns -o jsonpath='{.status.readyReplicas}' 2>/dev/null)
[ "$listo" = "1" ] || { echo "El Deployment 'saludo' todavia no tiene su replica lista (ahora: '$listo')"; exit 1; }
