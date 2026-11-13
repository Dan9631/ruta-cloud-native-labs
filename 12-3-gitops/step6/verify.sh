#!/bin/bash
# Reto del modulo 12, parte C (GitOps): portado de labs/12-application-delivery-gitops/check.ps1.
ns=lab-12
falta() { echo "FALTA: $1"; exit 1; }

[ "$(kubectl get application gitops-demo -n argocd -o jsonpath='{.status.sync.status}/{.status.health.status}' 2>/dev/null)" = "Synced/Healthy" ] \
  || falta "la Application 'gitops-demo' debe estar Synced y Healthy (si acabas de hacer push, fuerza el refresh y espera)"

[ "$(kubectl get deploy gitops-web -n $ns -o jsonpath='{.spec.replicas}/{.status.readyReplicas}' 2>/dev/null)" = "3/3" ] \
  || falta "'gitops-web' debe tener 3 replicas listas, cambiadas con un commit (no con kubectl)"

[ "$(kubectl get cm gitops-config -n $ns -o jsonpath='{.data.entorno}' 2>/dev/null)" = "lab" ] \
  || falta "no existe el ConfigMap 'gitops-config' con entorno=lab en $ns"
case "$(kubectl get cm gitops-config -n $ns -o jsonpath='{.metadata.annotations.argocd\.argoproj\.io/tracking-id}' 2>/dev/null)" in
  gitops-demo:*) ;;
  *) falta "el ConfigMap 'gitops-config' debe crearlo Argo CD desde el repo, no kubectl" ;;
esac

echo "Reto superado"
