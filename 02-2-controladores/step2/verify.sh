#!/bin/bash
# Se borro un Pod de hola y el ReplicaSet lo repuso: hay 2 replicas listas y los Pods
# vivos se crearon en momentos distintos (el repuesto es al menos 5 s mas nuevo).
estado=$(kubectl get deploy hola -n lab-02 -o jsonpath='{.spec.replicas}/{.status.readyReplicas}' 2>/dev/null)
[ "$estado" = "2/2" ] || { echo "El Deployment hola debe volver a tener 2 replicas listas (ahora: '$estado')"; exit 1; }

min=""; max=""
for ts in $(kubectl get pods -n lab-02 -l app=hola -o jsonpath='{range .items[*]}{.metadata.creationTimestamp}{"\n"}{end}'); do
  s=$(date -d "$ts" +%s 2>/dev/null) || continue
  [ -z "$min" ] || [ "$s" -lt "$min" ] && min=$s
  [ -z "$max" ] || [ "$s" -gt "$max" ] && max=$s
done
[ -n "$min" ] && [ $((max - min)) -ge 5 ] || { echo "No se ve ningun Pod repuesto: borra uno de los Pods de hola y espera a que aparezca otro"; exit 1; }
