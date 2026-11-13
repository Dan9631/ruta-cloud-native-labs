#!/bin/bash
# node01 tiene la label lab-04-gpu=true.
valor=$(kubectl get node node01 -o jsonpath='{.metadata.labels.lab-04-gpu}' 2>/dev/null)
[ "$valor" = "true" ] || { echo "Falta la label lab-04-gpu=true en node01 (ahora: '$valor')"; exit 1; }
