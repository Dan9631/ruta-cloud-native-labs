#!/bin/bash
# whoami-v1 (2 replicas) y whoami-v2 (1 replica) listos, cada uno con su Service.
v1=$(kubectl get deploy whoami-v1 -n lab-07 -o jsonpath='{.status.readyReplicas}' 2>/dev/null)
[ "$v1" = "2" ] || { echo "whoami-v1 deberia tener 2 replicas listas en lab-07 (ahora: '$v1')"; exit 1; }
v2=$(kubectl get deploy whoami-v2 -n lab-07 -o jsonpath='{.status.readyReplicas}' 2>/dev/null)
[ "$v2" = "1" ] || { echo "whoami-v2 deberia tener 1 replica lista en lab-07 (ahora: '$v2')"; exit 1; }
for s in whoami-v1 whoami-v2; do
  kubectl get svc "$s" -n lab-07 >/dev/null 2>&1 || { echo "Falta el Service $s en lab-07"; exit 1; }
done
