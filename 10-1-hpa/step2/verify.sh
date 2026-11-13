#!/bin/bash
# El generador de carga corre y el HPA ya ha subido php-apache a 2 o mas replicas.
ns=lab-10
gen=$(kubectl get deploy generador-carga -n $ns -o jsonpath='{.status.readyReplicas}' 2>/dev/null)
[ "${gen:-0}" -ge 1 ] || { echo "Falta el generador de carga en marcha: aplica 03-generador-carga.yaml"; exit 1; }
rep=$(kubectl get hpa php-apache -n $ns -o jsonpath='{.status.currentReplicas}' 2>/dev/null)
[ "${rep:-0}" -ge 2 ] || { echo "El HPA aun no ha escalado (replicas: '${rep:-0}'): espera un minuto y vuelve a mirar"; exit 1; }
