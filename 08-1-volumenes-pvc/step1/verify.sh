#!/bin/bash
# El Pod compartido esta listo, con sus dos contenedores y un volumen emptyDir.
listo=$(kubectl get pod compartido -n lab-08 -o jsonpath='{.status.conditions[?(@.type=="Ready")].status}' 2>/dev/null)
[ "$listo" = "True" ] || { echo "Falta el Pod compartido en lab-08 y listo (ahora: '$listo')"; exit 1; }
kubectl get pod compartido -n lab-08 -o jsonpath='{.spec.volumes[*].emptyDir}' | grep -q . \
  || { echo "El Pod compartido deberia montar un volumen emptyDir: aplica /root/lab/01-emptydir.yaml"; exit 1; }
kubectl logs compartido -n lab-08 -c lector 2>/dev/null | grep -q 'escrito por compartido' \
  || { echo "El contenedor lector todavia no ha leido nada: espera unos segundos y repite"; exit 1; }
