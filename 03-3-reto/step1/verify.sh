#!/bin/bash
# Reto del modulo 03: Deployment 'web' actualizado con rolling update, ConfigMap montado y Secret como variable.
ns=lab-03
falta() { echo "FALTA: $1"; exit 1; }

kubectl get deploy web -n $ns >/dev/null 2>&1 || falta "no existe el Deployment 'web' en $ns"

[ "$(kubectl get deploy web -n $ns -o jsonpath='{.spec.replicas}/{.status.readyReplicas}')" = "3/3" ] \
  || falta "el Deployment 'web' debe tener 3 replicas listas"

[ "$(kubectl get deploy web -n $ns -o jsonpath='{.spec.template.metadata.labels.app}')" = "web" ] \
  || falta "los Pods del Deployment deben llevar el label app=web"

[ "$(kubectl get deploy web -n $ns -o jsonpath='{.spec.template.spec.containers[0].image}/{.status.updatedReplicas}')" = "nginx:1.28-alpine/3" ] \
  || falta "el Deployment debe usar nginx:1.28-alpine con las 3 replicas actualizadas"

rev=$(kubectl get deploy web -n $ns -o jsonpath='{.metadata.annotations.deployment\.kubernetes\.io/revision}')
[ "${rev:-0}" -ge 2 ] || falta "el historial debe tener al menos 2 revisiones"
kubectl get rs -n $ns -o jsonpath='{range .items[*]}{.metadata.ownerReferences[0].name}={.spec.template.spec.containers[0].image}{"\n"}{end}' | grep -qx 'web=nginx:1.27-alpine' \
  || falta "el Deployment debe haberse creado primero con nginx:1.27-alpine"

[ "$(kubectl get deploy web -n $ns -o jsonpath='{.spec.strategy.type}/{.spec.strategy.rollingUpdate.maxSurge}/{.spec.strategy.rollingUpdate.maxUnavailable}')" = "RollingUpdate/1/0" ] \
  || falta "la estrategia debe ser RollingUpdate con maxSurge 1 y maxUnavailable 0"

cm=$(kubectl get configmap web-config -n $ns -o jsonpath='{.data.index\.html}' 2>/dev/null)
[ -n "$cm" ] || falta "no existe el ConfigMap 'web-config' con la clave index.html"
servido=$(kubectl exec deploy/web -n $ns -- wget -qO- http://localhost/ 2>/dev/null)
[ "$servido" = "$cm" ] || falta "nginx no sirve el index.html del ConfigMap: revisa el montaje en /usr/share/nginx/html"

kubectl get secret web-secret -n $ns -o jsonpath='{.data.api-token}' 2>/dev/null | grep -q . \
  || falta "no existe el Secret 'web-secret' con la clave api-token"
kubectl get deploy web -n $ns -o jsonpath='{range .spec.template.spec.containers[0].env[*]}{.name}={.valueFrom.secretKeyRef.name}/{.valueFrom.secretKeyRef.key}{"\n"}{end}' | grep -qx 'API_TOKEN=web-secret/api-token' \
  || falta "la variable API_TOKEN debe venir del Secret 'web-secret', clave api-token, con secretKeyRef"

echo "Reto superado"
