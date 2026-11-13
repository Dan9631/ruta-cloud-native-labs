#!/bin/bash
# El Deployment api salio del archivo /root/api.yaml, tiene 4 replicas y se aplico tambien con server-side apply.
grep -q 'replicas: 4' /root/api.yaml 2>/dev/null || { echo "El archivo /root/api.yaml deberia pedir 4 replicas"; exit 1; }
replicas=$(kubectl get deploy api -n lab-03 -o jsonpath='{.spec.replicas}' 2>/dev/null)
[ "$replicas" = "4" ] || { echo "El Deployment api deberia tener 4 replicas en lab-03 (ahora: '$replicas')"; exit 1; }
kubectl get deploy api -n lab-03 --show-managed-fields -o jsonpath='{range .metadata.managedFields[*]}{.operation}{"\n"}{end}' 2>/dev/null | grep -qx 'Apply' \
  || { echo "Falta aplicar /root/api.yaml con --server-side"; exit 1; }
