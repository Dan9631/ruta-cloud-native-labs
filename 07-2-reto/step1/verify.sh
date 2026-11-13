#!/bin/bash
# Reto del modulo 07: Pod con sidecar nativo que lee los logs de la app y HTTPRoute con cabecera + 80/20.
ns=lab-07
falta() { echo "FALTA: $1"; exit 1; }

# 1. Pod reto-sidecar Ready con un contenedor 'app'
kubectl get pod reto-sidecar -n $ns >/dev/null 2>&1 || falta "no existe el Pod 'reto-sidecar' en $ns"
[ "$(kubectl get pod reto-sidecar -n $ns -o jsonpath='{.status.conditions[?(@.type=="Ready")].status}')" = "True" ] \
  || falta "el Pod 'reto-sidecar' no esta Ready"
kubectl get pod reto-sidecar -n $ns -o jsonpath='{.spec.containers[*].name}' | tr ' ' '\n' | grep -qx app \
  || falta "el Pod 'reto-sidecar' debe tener un contenedor principal llamado 'app'"

# 2. shipper es un sidecar nativo
[ "$(kubectl get pod reto-sidecar -n $ns -o jsonpath='{.spec.initContainers[?(@.name=="shipper")].restartPolicy}')" = "Always" ] \
  || falta "'shipper' debe ser un sidecar nativo: un initContainer con restartPolicy: Always"

# 3. Los logs de shipper muestran lo que escribe app
kubectl logs reto-sidecar -n $ns -c shipper --tail=5 2>/dev/null | grep -q 'pedido procesado' \
  || falta "los logs de 'shipper' deben mostrar las lineas 'pedido procesado' que escribe 'app'"

# 4. HTTPRoute reto-canary con una regla que reparte 80/20
kubectl get httproute reto-canary -n $ns >/dev/null 2>&1 || falta "no existe la HTTPRoute 'reto-canary' en $ns"
kubectl get httproute reto-canary -n $ns -o jsonpath='{range .spec.rules[*]}{range .backendRefs[*]}{.name}={.weight},{end}{"\n"}{end}' \
  | grep 'whoami-v1=80,' | grep -q 'whoami-v2=20,' \
  || falta "la HTTPRoute 'reto-canary' debe tener una regla que reparta 80/20 entre whoami-v1 y whoami-v2"

# 5. Con la cabecera x-version: v2 responde siempre v2 (a traves del Gateway)
ip=$(kubectl get node controlplane -o jsonpath='{.status.addresses[?(@.type=="InternalIP")].address}')
url="http://$ip:30080/lab07/reto"
nombres=$(for i in 1 2 3 4 5; do r=$(curl -s -m 10 -H 'x-version: v2' "$url" | grep -o '^Name: v[0-9]*'); echo "${r:-ninguna}"; done | sort -u | tr '\n' ' ')
[ "$nombres" = "Name: v2 " ] \
  || falta "con la cabecera x-version: v2, $url debe responder SIEMPRE v2 (en 5 peticiones se vio: '$nombres')"

# 6. Sin cabecera responde whoami (v1 o v2)
curl -s -m 10 "$url" | grep -q '^Name: v[12]' \
  || falta "sin cabecera, $url debe responder whoami (v1 o v2): revisa que la ruta cuelgue de traefik-gateway en el namespace traefik"

echo "Reto superado"
