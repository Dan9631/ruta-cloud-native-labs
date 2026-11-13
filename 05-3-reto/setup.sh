#!/bin/bash
# Se ejecuta en segundo plano al abrir el escenario: espera al cluster, crea el namespace del laboratorio
# y le aplica el perfil restricted de Pod Security Admission, como queda al final de la segunda parte.
until kubectl get nodes >/dev/null 2>&1; do sleep 2; done
kubectl create namespace lab-05 --dry-run=client -o yaml | kubectl apply -f -
kubectl label --overwrite ns lab-05 pod-security.kubernetes.io/enforce=restricted pod-security.kubernetes.io/warn=restricted
mkdir -p /root/lab
touch /tmp/listo
