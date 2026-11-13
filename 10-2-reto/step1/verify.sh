#!/bin/bash
# Reto del modulo 10: Deployment 'web' + HPA 'web' (autoscaling/v2) con min 2, max 6, CPU 60% y ventana de bajada de 60 s.
ns=lab-10
falta() { echo "FALTA: $1"; exit 1; }
hpa() { kubectl get hpa.v2.autoscaling web -n $ns -o jsonpath="$1" 2>/dev/null; }

kubectl get deploy web -n $ns >/dev/null 2>&1 || falta "no existe el Deployment 'web' en $ns"

[ "$(kubectl get deploy web -n $ns -o jsonpath='{.spec.template.spec.containers[0].image}')" = "nginx:1.27-alpine" ] \
  || falta "el Deployment 'web' debe usar la imagen nginx:1.27-alpine"
[ -n "$(kubectl get deploy web -n $ns -o jsonpath='{.spec.template.spec.containers[0].resources.requests.cpu}')" ] \
  || falta "el Deployment 'web' debe definir requests.cpu (sin requests el HPA no puede calcular el porcentaje)"

kubectl get hpa web -n $ns >/dev/null 2>&1 || falta "no existe el HPA 'web' en $ns"

[ "$(hpa '{.spec.scaleTargetRef.kind}/{.spec.scaleTargetRef.name}/{.spec.minReplicas}/{.spec.maxReplicas}')" = "Deployment/web/2/6" ] \
  || falta "el HPA 'web' debe apuntar al Deployment 'web' con minReplicas 2 y maxReplicas 6"

[ "$(hpa '{.spec.metrics[?(@.resource.name=="cpu")].type}/{.spec.metrics[?(@.resource.name=="cpu")].resource.target.type}/{.spec.metrics[?(@.resource.name=="cpu")].resource.target.averageUtilization}')" = "Resource/Utilization/60" ] \
  || falta "el HPA 'web' debe usar la metrica de recurso cpu con averageUtilization 60"

[ "$(hpa '{.spec.behavior.scaleDown.stabilizationWindowSeconds}')" = "60" ] \
  || falta "el HPA 'web' debe tener behavior.scaleDown.stabilizationWindowSeconds 60"

activo=$(hpa '{.status.conditions[?(@.type=="ScalingActive")].status}')
metrica=$(hpa '{.status.currentMetrics[0].resource.current.averageUtilization}')
listos=$(kubectl get deploy web -n $ns -o jsonpath='{.status.readyReplicas}')
[ "$activo" = "True" ] && [ -n "$metrica" ] && [ "${listos:-0}" -ge 2 ] \
  || falta "el HPA aun no funciona (ScalingActive='$activo', CPU='$metrica', replicas listas='${listos:-0}'): si lo demas esta bien, espera un minuto"

echo "Reto superado"
