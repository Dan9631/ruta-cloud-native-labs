#!/bin/bash
# Deployment frontend con 3 replicas listas, imagen 1.27 y el motivo del cambio anotado.
estado=$(kubectl get deploy frontend -n lab-03 -o jsonpath='{.status.readyReplicas}/{.spec.template.spec.containers[0].image}' 2>/dev/null)
[ "$estado" = "3/nginx:1.27-alpine" ] || { echo "frontend deberia tener 3 replicas listas con nginx:1.27-alpine (ahora: '$estado')"; exit 1; }
causa=$(kubectl get deploy frontend -n lab-03 -o jsonpath='{.metadata.annotations.kubernetes\.io/change-cause}' 2>/dev/null)
[ -n "$causa" ] || { echo "Falta la annotation kubernetes.io/change-cause en el Deployment frontend"; exit 1; }
