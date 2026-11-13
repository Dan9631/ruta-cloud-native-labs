#!/bin/bash
# Reto modulo 09, caso 2: el Deployment api esta sano.
ns=lab-09
falta() { echo "FALTA: $1"; exit 1; }

# sana APP MIN: el Deployment APP tiene al menos MIN replicas, todas actualizadas y listas,
# y sus Pods actuales estan Running, sin estados de espera y sin reinicios.
sana() {
  app=$1; min=$2
  kubectl get deploy "$app" -n $ns >/dev/null 2>&1 || falta "no existe el Deployment '$app' en $ns"
  d=$(kubectl get deploy "$app" -n $ns -o jsonpath='{.spec.replicas}/{.status.replicas}/{.status.updatedReplicas}/{.status.readyReplicas}')
  r=${d%%/*}
  [ "${r:-0}" -ge "$min" ] || falta "el Deployment '$app' debe tener al menos $min replica(s) (ahora: ${r:-0})"
  [ "$d" = "$r/$r/$r/$r" ] || falta "el Deployment '$app' no tiene todas sus replicas actualizadas y listas (replicas/actuales/actualizadas/listas: $d)"
  pods=$(kubectl get pods -n $ns -l app="$app" -o jsonpath='{range .items[*]}{.metadata.name}|{.metadata.deletionTimestamp}|{.status.phase}|{.status.containerStatuses[0].restartCount}|{.status.containerStatuses[0].state.waiting.reason}{"\n"}{end}' | awk -F'|' 'NF && $2==""')
  [ "$(echo "$pods" | grep -c .)" -ge "$min" ] || falta "faltan Pods de '$app' en marcha"
  mal=$(echo "$pods" | awk -F'|' '$3!="Running" || $5!="" {print $1" ("$3" "$5")"}' | head -1)
  [ -z "$mal" ] || falta "el Pod $mal de '$app' no esta sano"
  rein=$(echo "$pods" | awk -F'|' '$4!="0" {print $1}' | head -1)
  [ -z "$rein" ] || falta "el Pod $rein de '$app' se ha reiniciado. Si lo arreglaste tarde: kubectl rollout restart deployment/$app -n $ns"
}

sana api 1
echo "Caso 2 resuelto"
