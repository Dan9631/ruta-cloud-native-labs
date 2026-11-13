#!/bin/bash
# El Deployment hola existe en lab-02 con 2 replicas listas.
estado=$(kubectl get deploy hola -n lab-02 -o jsonpath='{.spec.replicas}/{.status.readyReplicas}' 2>/dev/null)
[ "$estado" = "2/2" ] || { echo "Falta el Deployment hola en lab-02 con 2 replicas listas (ahora: '$estado')"; exit 1; }
