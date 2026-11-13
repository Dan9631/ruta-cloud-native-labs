#!/bin/bash
# Se ejecuta en segundo plano al abrir el escenario: espera al cluster, deja que controlplane
# admita Pods (para repartirlos entre los dos nodos) y crea el namespace del laboratorio.
until kubectl get nodes >/dev/null 2>&1; do sleep 2; done
kubectl taint nodes controlplane node-role.kubernetes.io/control-plane:NoSchedule- >/dev/null 2>&1 || true
kubectl create namespace lab-06 --dry-run=client -o yaml | kubectl apply -f -
mkdir -p /root/lab
touch /tmp/listo
