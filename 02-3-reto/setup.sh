#!/bin/bash
# Se ejecuta en segundo plano al abrir el escenario: espera al cluster y crea el namespace del laboratorio.
until kubectl get nodes >/dev/null 2>&1; do sleep 2; done
kubectl create namespace lab-02 --dry-run=client -o yaml | kubectl apply -f -
touch /tmp/listo
