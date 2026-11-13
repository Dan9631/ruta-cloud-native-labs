#!/bin/bash
# whoami con 3 replicas listas, Service ClusterIP whoami y Pod cliente Running en lab-06.
ns=lab-06
listas=$(kubectl get deploy whoami -n $ns -o jsonpath='{.status.readyReplicas}' 2>/dev/null)
[ "$listas" = "3" ] || { echo "Falta el Deployment whoami con 3 replicas listas en $ns (ahora: '${listas:-0}')"; exit 1; }
tipo=$(kubectl get svc whoami -n $ns -o jsonpath='{.spec.type}' 2>/dev/null)
[ "$tipo" = "ClusterIP" ] || { echo "Falta el Service whoami de tipo ClusterIP en $ns"; exit 1; }
fase=$(kubectl get pod cliente -n $ns -o jsonpath='{.status.phase}' 2>/dev/null)
[ "$fase" = "Running" ] || { echo "Falta el Pod cliente en Running en $ns (ahora: '$fase')"; exit 1; }
