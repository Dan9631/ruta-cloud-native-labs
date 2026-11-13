#!/bin/bash
# El ReplicaSet rs-demo esta escalado a 1 replica lista y el Pod intruso ya no existe.
estado=$(kubectl get rs rs-demo -n lab-03 -o jsonpath='{.spec.replicas}/{.status.readyReplicas}' 2>/dev/null)
[ "$estado" = "1/1" ] || { echo "rs-demo deberia tener 1 replica lista en lab-03 (ahora: '$estado')"; exit 1; }
if kubectl get pod intruso -n lab-03 >/dev/null 2>&1; then echo "El Pod intruso sigue existiendo: espera a que el ReplicaSet lo borre"; exit 1; fi
