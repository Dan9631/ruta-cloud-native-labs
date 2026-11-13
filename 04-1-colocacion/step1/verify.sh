#!/bin/bash
# web-libre con 4 replicas listas y el Pod manual Running en node01.
ns=lab-04
listo=$(kubectl get deploy web-libre -n $ns -o jsonpath='{.status.readyReplicas}' 2>/dev/null)
[ "$listo" = "4" ] || { echo "Falta el Deployment web-libre con 4 replicas listas (ahora: '${listo:-0}')"; exit 1; }
estado=$(kubectl get pod manual -n $ns -o jsonpath='{.spec.nodeName}/{.status.phase}' 2>/dev/null)
[ "$estado" = "node01/Running" ] || { echo "Falta el Pod manual Running en node01 (ahora: '$estado')"; exit 1; }
