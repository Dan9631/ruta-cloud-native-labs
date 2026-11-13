#!/bin/bash
# Pod web-con-sidecar listo, con log-tail como sidecar nativo (initContainer con restartPolicy: Always).
listo=$(kubectl get pod web-con-sidecar -n lab-07 -o jsonpath='{.status.conditions[?(@.type=="Ready")].status}' 2>/dev/null)
[ "$listo" = "True" ] || { echo "El Pod web-con-sidecar deberia existir en lab-07 y estar Ready (ahora: '$listo')"; exit 1; }
sidecar=$(kubectl get pod web-con-sidecar -n lab-07 -o jsonpath='{.spec.initContainers[?(@.name=="log-tail")].restartPolicy}' 2>/dev/null)
[ "$sidecar" = "Always" ] || { echo "log-tail deberia ser un initContainer con restartPolicy: Always (ahora: '$sidecar')"; exit 1; }
