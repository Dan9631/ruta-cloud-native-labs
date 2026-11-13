#!/bin/bash
# La Application gitops-demo existe, esta Synced/Healthy y Argo CD creo gitops-web con 2 replicas.
kubectl get application gitops-demo -n argocd >/dev/null 2>&1 || { echo "Falta la Application gitops-demo: kubectl apply -f /root/lab/gitops/application.yaml"; exit 1; }
e=$(kubectl get application gitops-demo -n argocd -o jsonpath='{.status.sync.status}/{.status.health.status}' 2>/dev/null)
[ "$e" = "Synced/Healthy" ] || { echo "gitops-demo todavia no esta Synced/Healthy (ahora: '$e'). Espera unos segundos"; exit 1; }
r=$(kubectl get deploy gitops-web -n lab-12 -o jsonpath='{.status.readyReplicas}/{.metadata.annotations.argocd\.argoproj\.io/tracking-id}' 2>/dev/null)
case "$r" in
  2/gitops-demo:*) ;;
  *) echo "gitops-web debe tener 2 replicas listas y haberlo creado Argo CD (ahora: '$r')"; exit 1 ;;
esac
