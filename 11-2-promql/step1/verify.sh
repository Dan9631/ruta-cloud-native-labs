#!/bin/bash
# El port-forward a prometheus-server responde en el puerto 9090 y Prometheus esta listo.
curl -sf --max-time 5 http://localhost:9090/-/ready >/dev/null \
  || { echo "Prometheus no responde en localhost:9090: lanza el kubectl port-forward con --address 0.0.0.0"; exit 1; }
curl -sf --max-time 5 'http://localhost:9090/api/v1/query?query=up' | grep -q '"status":"success"' \
  || { echo "La API de Prometheus en localhost:9090 no responde a la consulta 'up'"; exit 1; }
