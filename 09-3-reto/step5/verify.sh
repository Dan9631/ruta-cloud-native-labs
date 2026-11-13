#!/bin/bash
# Reto modulo 09, caso 6 y comprobacion final (port de check.ps1): las 6 apps sanas y el Service shop con endpoints y respondiendo.
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

sana frontend 2
sana api 1
sana cache 1
sana worker 1
sana reporter 1
sana shop 2

listos=$(kubectl get endpointslices -n $ns -l kubernetes.io/service-name=shop -o jsonpath='{range .items[*]}{range .endpoints[*]}{.conditions.ready}{"\n"}{end}{end}' 2>/dev/null | grep -c "^true$")
[ "$listos" -ge 2 ] || falta "el Service 'shop' debe tener al menos 2 endpoints listos (ahora: $listos): revisa su selector y que los Pods esten Ready"

p=$(kubectl get pods -n $ns -l app=frontend --field-selector=status.phase=Running -o name | head -1)
kubectl exec -n $ns "$p" -- wget -qO- -T 3 http://shop 2>/dev/null | grep -qi nginx \
  || falta "el Service 'shop' no responde por HTTP desde dentro del cluster"

echo "Reto superado: las 6 aplicaciones estan sanas"
