#!/bin/bash
# Reto del modulo 04 (version de 2 nodos): taint en node01, Pod que lo tolera y va a zona-b,
# Deployment Guaranteed en el nodo ssd, DaemonSet en todos los nodos y cuota de 10 Pods.
ns=lab-04
falta() { echo "FALTA: $1"; exit 1; }

# 1. Taint del reto en node01
kubectl get node node01 -o jsonpath='{range .spec.taints[*]}{.key}={.value}:{.effect}{"\n"}{end}' \
  | grep -qx 'lab-04-reto=gpu:NoSchedule' \
  || falta "el nodo node01 debe tener el taint lab-04-reto=gpu:NoSchedule"

# 2. Pod entrenamiento: Running en node01, tolera lab-04-reto y usa zone=zona-b
kubectl get pod entrenamiento -n $ns >/dev/null 2>&1 || falta "no existe el Pod 'entrenamiento' en $ns"
[ "$(kubectl get pod entrenamiento -n $ns -o jsonpath='{.status.phase}/{.spec.nodeName}')" = "Running/node01" ] \
  || falta "el Pod 'entrenamiento' debe estar Running en node01"
kubectl get pod entrenamiento -n $ns -o jsonpath='{range .spec.tolerations[*]}{.key}|{.operator}{"\n"}{end}' \
  | grep -Eq '^lab-04-reto\||^\|Exists$' \
  || falta "el Pod 'entrenamiento' debe tolerar el taint lab-04-reto"
kubectl get pod entrenamiento -n $ns -o jsonpath='{.spec.nodeSelector} {.spec.affinity}' | grep -q 'zona-b' \
  || falta "el Pod 'entrenamiento' debe ir a node01 por su label zone=zona-b (nodeSelector o node affinity), no por nodeName"

# 3. Deployment api: 2 replicas listas, todas en el nodo disktype=ssd
ssd=$(kubectl get nodes -l disktype=ssd -o jsonpath='{.items[*].metadata.name}')
[ "$(kubectl get deploy api -n $ns -o jsonpath='{.status.readyReplicas}' 2>/dev/null)" = "2" ] \
  || falta "el Deployment 'api' debe tener 2 replicas listas"
nodos=$(kubectl get pods -n $ns -l app=api --field-selector=status.phase=Running -o jsonpath='{range .items[*]}{.spec.nodeName}{"\n"}{end}')
[ "$(echo "$nodos" | grep -c .)" = "2" ] || falta "debe haber exactamente 2 Pods de 'api' (label app=api) en marcha"
for n in $nodos; do
  [ "$n" = "$ssd" ] || falta "los Pods de 'api' solo pueden correr en el nodo disktype=ssd ($ssd); hay uno en $n"
done

# 4. QoS Guaranteed en los Pods de api
qos=$(kubectl get pods -n $ns -l app=api --field-selector=status.phase=Running -o jsonpath='{range .items[*]}{.status.qosClass}{"\n"}{end}')
[ "$(echo "$qos" | grep -c .)" -ge 2 ] && [ "$(echo "$qos" | grep -vcx Guaranteed)" = "0" ] \
  || falta "los Pods de 'api' deben tener QoS class Guaranteed (requests == limits en CPU y memoria)"

# 5. DaemonSet monitor con un Pod listo en cada nodo
total=$(kubectl get nodes --no-headers | grep -c .)
[ "$(kubectl get ds monitor -n $ns -o jsonpath='{.status.desiredNumberScheduled}/{.status.numberReady}' 2>/dev/null)" = "$total/$total" ] \
  || falta "el DaemonSet 'monitor' debe tener un Pod listo en cada uno de los $total nodos (revisa los taints)"

# 6. ResourceQuota de 10 Pods
[ "$(kubectl get resourcequota cuota -n $ns -o jsonpath='{.spec.hard.pods}' 2>/dev/null)" = "10" ] \
  || falta "la ResourceQuota 'cuota' debe limitar $ns a 10 Pods"

echo "Reto superado"
