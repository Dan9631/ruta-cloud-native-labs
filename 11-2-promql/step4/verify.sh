#!/bin/bash
# El Pod 'pendiente' esta en Pending y Prometheus ya lo ve a traves de kube-state-metrics.
fase=$(kubectl get pod pendiente -n lab-11 -o jsonpath='{.status.phase}' 2>/dev/null)
[ "$fase" = "Pending" ] || { echo "Falta el Pod 'pendiente' en lab-11 en Pending (ahora: '$fase'). Aplica /root/lab/pendiente.yaml"; exit 1; }
# Consulta: kube_pod_status_phase{namespace="lab-11", pod="pendiente", phase="Pending"} == 1 (codificada para la URL)
q='kube_pod_status_phase%7Bnamespace%3D%22lab-11%22%2Cpod%3D%22pendiente%22%2Cphase%3D%22Pending%22%7D%20%3D%3D%201'
kubectl get --raw "/api/v1/namespaces/lab-11/services/prometheus-server:80/proxy/api/v1/query?query=$q" 2>/dev/null | grep -q '"metric"' \
  || { echo "Prometheus todavia no ve el Pod 'pendiente' en Pending: espera 30 segundos (dos scrapes) y repite"; exit 1; }
