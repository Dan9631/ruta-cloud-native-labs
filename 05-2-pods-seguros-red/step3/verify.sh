#!/bin/bash
# Los Pods api, frontend e intruso estan listos y existen las dos NetworkPolicies con la forma esperada.
# Se comprueban los objetos, no el trafico: el efecto depende de que el CNI del cluster aplique NetworkPolicies.
for p in api frontend intruso; do
  listo=$(kubectl get pod $p -n lab-05 -o jsonpath='{.status.conditions[?(@.type=="Ready")].status}' 2>/dev/null)
  [ "$listo" = "True" ] || { echo "El Pod $p no esta listo en lab-05: aplica 07-np-app.yaml"; exit 1; }
done
deny=$(kubectl get networkpolicy default-deny-ingress -n lab-05 -o jsonpath='{.spec.policyTypes[0]}/{.spec.podSelector.matchLabels}/{.spec.ingress}' 2>/dev/null)
[ "$deny" = "Ingress//" ] || { echo "Falta la NetworkPolicy default-deny-ingress (todos los Pods, Ingress, sin reglas): aplica 08-np-default-deny.yaml"; exit 1; }
abre=$(kubectl get networkpolicy permitir-frontend -n lab-05 -o jsonpath='{.spec.podSelector.matchLabels.app}/{.spec.ingress[0].from[0].podSelector.matchLabels.role}/{.spec.ingress[0].ports[0].port}' 2>/dev/null)
[ "$abre" = "api/frontend/8080" ] || { echo "Falta la NetworkPolicy permitir-frontend (app=api, desde role=frontend, puerto 8080): aplica 09-np-permitir-frontend.yaml"; exit 1; }
if kubectl get pod pod-root -n lab-05 >/dev/null 2>&1; then echo "Borra pod-root, como indica el principio del paso"; exit 1; fi
