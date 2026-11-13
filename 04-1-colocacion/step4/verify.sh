#!/bin/bash
# web-afinidad con 4 replicas listas; cache con 2 replicas listas en nodos distintos y 1 Pending.
ns=lab-04
listo=$(kubectl get deploy web-afinidad -n $ns -o jsonpath='{.status.readyReplicas}' 2>/dev/null)
[ "$listo" = "4" ] || { echo "Falta el Deployment web-afinidad con 4 replicas listas (ahora: '${listo:-0}')"; exit 1; }
estado=$(kubectl get deploy cache -n $ns -o jsonpath='{.spec.replicas}/{.status.readyReplicas}' 2>/dev/null)
[ "$estado" = "3/2" ] || { echo "Falta el Deployment cache con 3 replicas pedidas y 2 listas (ahora: '$estado')"; exit 1; }
nodos=$(kubectl get pods -n $ns -l app=cache --field-selector=status.phase=Running -o jsonpath='{range .items[*]}{.spec.nodeName}{"\n"}{end}' | sort -u | grep -c .)
[ "$nodos" = "2" ] || { echo "Las 2 replicas de cache en marcha deberian estar en nodos distintos"; exit 1; }
pend=$(kubectl get pods -n $ns -l app=cache --field-selector=status.phase=Pending -o name | grep -c .)
[ "$pend" = "1" ] || { echo "Deberia quedar exactamente 1 replica de cache en Pending (ahora: $pend)"; exit 1; }
