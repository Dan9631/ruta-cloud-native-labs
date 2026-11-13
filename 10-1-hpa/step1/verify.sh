#!/bin/bash
# La app php-apache esta lista, el HPA existe y ya lee la CPU (TARGETS con porcentaje, no <unknown>).
ns=lab-10
listos=$(kubectl get deploy php-apache -n $ns -o jsonpath='{.status.readyReplicas}' 2>/dev/null)
[ "${listos:-0}" -ge 1 ] || { echo "Falta el Deployment php-apache en $ns con al menos un Pod listo: aplica 01-php-apache.yaml"; exit 1; }
max=$(kubectl get hpa php-apache -n $ns -o jsonpath='{.spec.maxReplicas}' 2>/dev/null)
[ "$max" = "4" ] || { echo "Falta el HPA php-apache en $ns: aplica 02-hpa.yaml"; exit 1; }
cpu=$(kubectl get hpa php-apache -n $ns -o jsonpath='{.status.currentMetrics[0].resource.current.averageUtilization}' 2>/dev/null)
[ -n "$cpu" ] || { echo "El HPA todavia muestra <unknown>: espera un minuto a que metrics-server tenga muestras"; exit 1; }
