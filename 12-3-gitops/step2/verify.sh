#!/bin/bash
# El servidor git (Deployment y Service git-server) esta listo en lab-12.
r=$(kubectl get deploy git-server -n lab-12 -o jsonpath='{.status.readyReplicas}' 2>/dev/null)
[ "$r" = "1" ] || { echo "Falta el Deployment git-server listo en lab-12: kubectl apply -k /root/lab/gitops (ahora: '$r')"; exit 1; }
kubectl get svc git-server -n lab-12 >/dev/null 2>&1 || { echo "Falta el Service git-server en lab-12"; exit 1; }
