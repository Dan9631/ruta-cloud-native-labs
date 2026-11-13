#!/bin/bash
# web-repartida con 5 replicas listas, repartidas 3/2 entre zona-a (controlplane) y zona-b (node01).
ns=lab-04
estado=$(kubectl get deploy web-repartida -n $ns -o jsonpath='{.spec.replicas}/{.status.readyReplicas}' 2>/dev/null)
[ "$estado" = "5/5" ] || { echo "Falta el Deployment web-repartida escalado a 5 replicas listas (ahora: '$estado')"; exit 1; }
nodos=$(kubectl get pods -n $ns -l app=web-repartida --field-selector=status.phase=Running -o jsonpath='{range .items[*]}{.spec.nodeName}{"\n"}{end}')
a=$(echo "$nodos" | grep -cx controlplane)
b=$(echo "$nodos" | grep -cx node01)
if [ "$a/$b" != "3/2" ] && [ "$a/$b" != "2/3" ]; then
  echo "Las 5 replicas deberian quedar 3 y 2 entre zona-a y zona-b (ahora: controlplane=$a, node01=$b)"; exit 1
fi
