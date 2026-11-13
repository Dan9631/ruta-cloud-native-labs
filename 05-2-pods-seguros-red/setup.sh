#!/bin/bash
# Se ejecuta en segundo plano al abrir el escenario: espera al cluster, crea el namespace del laboratorio
# y la ServiceAccount 'lector' de la primera parte (solo puede leer Pods en lab-05), que se usa en el paso 4.
until kubectl get nodes >/dev/null 2>&1; do sleep 2; done
kubectl create namespace lab-05 --dry-run=client -o yaml | kubectl apply -f -
kubectl create serviceaccount lector -n lab-05 --dry-run=client -o yaml | kubectl apply -f -
kubectl create role lector-pods -n lab-05 --verb=get,list,watch --resource=pods,pods/log --dry-run=client -o yaml | kubectl apply -f -
kubectl create rolebinding lector-pods -n lab-05 --role=lector-pods --serviceaccount=lab-05:lector --dry-run=client -o yaml | kubectl apply -f -
mkdir -p /root/lab
touch /tmp/listo
