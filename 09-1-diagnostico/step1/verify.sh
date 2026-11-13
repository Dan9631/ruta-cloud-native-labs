#!/bin/bash
# Los 6 Deployments rotos, sus 2 Services y el ConfigMap report-config existen en lab-09.
ns=lab-09
for d in frontend api cache worker reporter shop; do
  kubectl get deploy "$d" -n $ns >/dev/null 2>&1 || { echo "Falta el Deployment '$d' en $ns: aplica la carpeta /root/lab/rotos/"; exit 1; }
done
for s in frontend shop; do
  kubectl get svc "$s" -n $ns >/dev/null 2>&1 || { echo "Falta el Service '$s' en $ns: aplica la carpeta /root/lab/rotos/"; exit 1; }
done
kubectl get configmap report-config -n $ns >/dev/null 2>&1 || { echo "Falta el ConfigMap 'report-config' en $ns: aplica la carpeta /root/lab/rotos/"; exit 1; }
