#!/bin/bash
# Se ejecuta en segundo plano al abrir el escenario: espera al cluster, crea el namespace del laboratorio,
# instala helm (si falta), deja el comando "promql" e instala Prometheus con Helm
# (lo que el escenario 11-1 hace a mano, con el mismo chart y los mismos valores).
# En el paso 4 se usa /root/lab/pendiente.yaml.
# Versiones: las mismas que fija kcna.ps1 y el curso.
HELM_VERSION=v3.19.0
CHART_VERSION=29.37.2

reintenta() { for i in 1 2 3 4 5; do "$@" && return 0; sleep 5; done; return 1; }
fallo() { echo "$1" > /tmp/fallo; exit 1; }

until kubectl get nodes >/dev/null 2>&1; do sleep 2; done
kubectl create namespace lab-11 --dry-run=client -o yaml | kubectl apply -f -
mkdir -p /root/lab

# helm, si no viene instalado
if ! command -v helm >/dev/null 2>&1; then
  reintenta curl -fsSL "https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz" -o /tmp/helm.tgz \
    || fallo "no se pudo descargar helm"
  tar -xzf /tmp/helm.tgz -C /tmp linux-amd64/helm && install -m 0755 /tmp/linux-amd64/helm /usr/local/bin/helm
fi
command -v helm >/dev/null 2>&1 || fallo "helm no quedo instalado"

# Comando "promql": consulta la API HTTP de Prometheus por el proxy del apiserver (sin navegador ni port-forward)
cat > /usr/local/bin/promql <<'EOF'
#!/bin/bash
# promql 'CONSULTA' [--json]
# Ejecuta una consulta PromQL en el Prometheus de lab-11. Llama a la API HTTP de Prometheus
# (/api/v1/query) a traves del proxy del apiserver: no necesita port-forward ni navegador.
# Con --json muestra la respuesta tal cual; sin el, una linea por serie: labels y valor.
if [ -z "$1" ]; then echo "Uso: promql 'up'"; exit 1; fi
s="$1"; q=""
for ((i = 0; i < ${#s}; i++)); do
  c="${s:i:1}"
  case "$c" in
    [a-zA-Z0-9.~_-]) q+="$c" ;;
    *) printf -v h '%%%02X' "'$c"; q+="$h" ;;
  esac
done
raw=$(kubectl get --raw "/api/v1/namespaces/lab-11/services/prometheus-server:80/proxy/api/v1/query?query=$q") || exit 1
if [ "$2" = "--json" ] || ! command -v python3 >/dev/null 2>&1; then echo "$raw"; exit 0; fi
printf '%s' "$raw" | python3 -c '
import json, sys
r = json.load(sys.stdin)
if r.get("status") != "success":
    print(r.get("error", r)); sys.exit(1)
d = r["data"]
def num(v):
    x = float(v)
    return str(int(x)) if x.is_integer() else str(round(x, 3))
if d["resultType"] == "scalar":
    print(num(d["result"][1])); sys.exit(0)
res = d["result"]
if not res:
    print("(resultado vacio)")
for s in res:
    m = dict(s["metric"])
    nombre = m.pop("__name__", "")
    etiquetas = ", ".join(k + "=\"" + v + "\"" for k, v in sorted(m.items()))
    if d["resultType"] == "matrix":
        valor = " ".join(num(p[1]) for p in s["values"])
    else:
        valor = num(s["value"][1])
    print(nombre + "{" + etiquetas + "}  " + valor)
'
EOF
chmod +x /usr/local/bin/promql

# Valores del chart: los mismos que /root/lab/prometheus-values.yaml del escenario 11-1
cat > /root/lab/prometheus-values.yaml <<'EOF'
# Valores minimos para el chart prometheus-community/prometheus 29.37.2 (lab 11)
# Objetivo: un Prometheus ligero para aprender, sin almacenamiento persistente.
# Mismos valores que el lab local del curso. Unico cambio: la tolerancia explicita de node-exporter,
# para que corra tambien en controlplane aunque tenga el taint del plano de control.

server:
  persistentVolume:
    enabled: false          # TSDB en emptyDir: se pierde al borrar el pod (suficiente para el lab)
  retention: "6h"
  global:
    scrape_interval: 15s
    evaluation_interval: 15s
  resources:
    requests:
      cpu: 50m
      memory: 256Mi
    limits:
      memory: 768Mi         # ~100k series en memoria rondan los 400 MiB; aqui hay muchas menos

alertmanager:
  enabled: false            # alertas fuera del alcance del lab

prometheus-pushgateway:
  enabled: false            # solo para jobs batch de vida corta

kube-state-metrics:
  enabled: true             # estado de objetos de Kubernetes (kube_pod_status_phase, ...)
  resources:
    requests:
      cpu: 10m
      memory: 32Mi

prometheus-node-exporter:
  enabled: true             # metricas de cada nodo (CPU, memoria, disco) como DaemonSet
  tolerations:
    - operator: Exists      # un pod en cada nodo, incluido controlplane
  resources:
    requests:
      cpu: 10m
      memory: 16Mi
EOF

reintenta helm repo add prometheus-community https://prometheus-community.github.io/helm-charts --force-update \
  || fallo "no se pudo anadir el repositorio prometheus-community"
reintenta helm repo update prometheus-community || fallo "no se pudo actualizar el repositorio prometheus-community"
helm upgrade --install prometheus prometheus-community/prometheus --version "$CHART_VERSION" -n lab-11 \
  -f /root/lab/prometheus-values.yaml --wait --timeout 8m \
  || fallo "helm no pudo instalar Prometheus (mira kubectl get pods -n lab-11)"

# Espera a que Prometheus haya hecho al menos un scrape de sus targets
for i in $(seq 1 30); do
  promql 'count(up == 1)' 2>/dev/null | grep -qE '[1-9]' && break
  sleep 3
done

touch /tmp/listo
