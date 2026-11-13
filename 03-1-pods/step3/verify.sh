#!/bin/bash
# El Pod multi esta listo (sus dos contenedores principales) y el init container termino bien.
listo=$(kubectl get pod multi -n lab-03 -o jsonpath='{.status.conditions[?(@.type=="Ready")].status}/{.status.initContainerStatuses[0].state.terminated.reason}' 2>/dev/null)
[ "$listo" = "True/Completed" ] || { echo "El Pod multi todavia no esta Ready en lab-03 (ahora: '$listo')"; exit 1; }
