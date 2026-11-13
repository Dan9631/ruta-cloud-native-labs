#!/bin/bash
# Se ejecuta en segundo plano al abrir el escenario: espera al cluster, prepara los nodos como en el curso y crea el namespace.
until kubectl get nodes >/dev/null 2>&1; do sleep 2; done
# controlplane con su taint (las apps van a node01) y node01 con los labels del worker del curso.
kubectl taint nodes controlplane node-role.kubernetes.io/control-plane:NoSchedule --overwrite
kubectl label nodes node01 disktype=ssd zone=zona-a --overwrite
kubectl create namespace lab-09 --dry-run=client -o yaml | kubectl apply -f -
mkdir -p /root/lab/rotos
touch /tmp/listo
