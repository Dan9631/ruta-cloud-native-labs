#!/bin/bash
# Reto del modulo 11: Prometheus (release 'prometheus') en lab-11 descubriendo y scrapeando las 2 replicas de 'tienda'.
# Port de labs/11-observabilidad/check.ps1. Las consultas PromQL van por el proxy del apiserver.
ns=lab-11
falta() { echo "FALTA: $1"; exit 1; }

# Codifica una consulta PromQL para la URL (solo caracteres ASCII)
urlencode() {
  local s="$1" out="" c h i
  for ((i = 0; i < ${#s}; i++)); do
    c="${s:i:1}"
    case "$c" in
      [a-zA-Z0-9.~_-]) out+="$c" ;;
      *) printf -v h '%%%02X' "'$c"; out+="$h" ;;
    esac
  done
  printf '%s' "$out"
}
# Numero de series que devuelve una consulta (0 si falla)
series() {
  kubectl get --raw "/api/v1/namespaces/$ns/services/prometheus-server:80/proxy/api/v1/query?query=$(urlencode "$1")" 2>/dev/null \
    | grep -o '"metric"' | wc -l
}

kubectl get pods -n $ns -l 'app.kubernetes.io/name=prometheus,app.kubernetes.io/component=server' \
  -o jsonpath='{range .items[*]}{.status.conditions[?(@.type=="Ready")].status}{"\n"}{end}' 2>/dev/null | grep -qx True \
  || falta "Prometheus server corriendo en $ns (helm release 'prometheus', pod Ready). Espera a que termine la instalacion"

ksm=$(series 'up{job="kubernetes-service-endpoints", service="prometheus-kube-state-metrics"} == 1')
node=$(series 'up{job="kubernetes-service-endpoints", service="prometheus-prometheus-node-exporter"} == 1')
[ "$ksm" -ge 1 ] && [ "$node" -ge 1 ] \
  || falta "kube-state-metrics y node-exporter siendo scrapeados (up == 1)"

kubectl get deploy tienda -n $ns >/dev/null 2>&1 || falta "el Deployment 'tienda' en $ns: aplica /root/lab/02-tienda.yaml"

[ "$(kubectl get deploy tienda -n $ns -o jsonpath='{.status.readyReplicas}')" = "2" ] \
  || falta "el Deployment 'tienda' en $ns con 2 replicas listas"

anot=$(kubectl get deploy tienda -n $ns -o jsonpath='{.spec.template.metadata.annotations.prometheus\.io/scrape}|{.spec.template.metadata.annotations.prometheus\.io/port}|{.spec.template.metadata.annotations.prometheus\.io/path}')
[ "$anot" = "true|8080|/metrics.txt" ] \
  || falta "las anotaciones prometheus.io/scrape=\"true\", port=\"8080\" y path=\"/metrics.txt\" en los Pods de 'tienda' (spec.template.metadata), ahora: '$anot'"

[ "$(series 'up{job="kubernetes-pods", app="tienda"} == 1')" -ge 2 ] \
  || falta "Prometheus debe ver 2 targets de 'tienda' con up == 1 (job kubernetes-pods). Si acabas de aplicar el cambio, espera ~1 minuto"

[ "$(series 'sum(rate(tienda_pedidos_total[1m])) > 0')" -ge 1 ] \
  || falta "la metrica tienda_pedidos_total debe crecer: sum(rate(tienda_pedidos_total[1m])) > 0. Espera ~1 minuto y repite"

echo "Reto superado"
