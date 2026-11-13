#!/bin/bash
# Reto del modulo 12, parte A (Kustomize): portado de labs/12-application-delivery-gitops/check.ps1.
ns=lab-12
falta() { echo "FALTA: $1"; exit 1; }

[ "$(kubectl get deploy qa-web -n $ns -o jsonpath='{.status.readyReplicas}' 2>/dev/null)" = "2" ] \
  || falta "Deployment 'qa-web' en $ns con 2 replicas listas"

[ "$(kubectl get deploy qa-web -n $ns -o jsonpath='{.spec.template.spec.containers[0].image}/{.spec.template.metadata.labels.env}' 2>/dev/null)" = "nginx:1.28-alpine/qa" ] \
  || falta "'qa-web' debe usar la imagen nginx:1.28-alpine y sus Pods deben llevar env=qa"

[ "$(kubectl get svc qa-web -n $ns -o jsonpath='{.spec.selector.env}' 2>/dev/null)" = "qa" ] \
  || falta "el Service 'qa-web' debe seleccionar solo Pods con env=qa"

echo "Parte de Kustomize superada"
