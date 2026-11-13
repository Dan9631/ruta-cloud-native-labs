#!/bin/bash
# Argo CD core instalado en el namespace argocd: controlador, repo-server y redis listos, y el proyecto default.
kubectl get namespace argocd >/dev/null 2>&1 || { echo "Falta el namespace argocd y el manifiesto de Argo CD core"; exit 1; }
c=$(kubectl -n argocd get statefulset argocd-application-controller -o jsonpath='{.status.readyReplicas}' 2>/dev/null)
[ "$c" = "1" ] || { echo "argocd-application-controller todavia no esta listo (mira kubectl -n argocd get pods)"; exit 1; }
for d in argocd-repo-server argocd-redis; do
  r=$(kubectl -n argocd get deploy $d -o jsonpath='{.status.readyReplicas}' 2>/dev/null)
  [ "$r" = "1" ] || { echo "$d todavia no esta listo (mira kubectl -n argocd get pods)"; exit 1; }
done
kubectl -n argocd get appproject default >/dev/null 2>&1 || { echo "Falta el AppProject default: kubectl apply -f /root/lab/gitops/appproject-default.yaml"; exit 1; }
