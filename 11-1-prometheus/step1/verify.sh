#!/bin/bash
# El Pod registro esta Running en lab-11 y metrics-server ya responde a kubectl top.
fase=$(kubectl get pod registro -n lab-11 -o jsonpath='{.status.phase}' 2>/dev/null)
[ "$fase" = "Running" ] || { echo "Falta el Pod registro en lab-11 en Running (ahora: '$fase'). Aplica /root/lab/01-registro.yaml"; exit 1; }
nodos=$(kubectl top nodes --no-headers 2>/dev/null | wc -l)
[ "$nodos" -ge 2 ] || { echo "kubectl top nodes todavia no muestra los dos nodos: metrics-server tarda un minuto en tener datos. Espera y repite"; exit 1; }
