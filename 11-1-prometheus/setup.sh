#!/bin/bash
# Se ejecuta en segundo plano al abrir el escenario: espera al cluster, crea el namespace del laboratorio,
# instala helm (si falta) y metrics-server (si falta, con --kubelet-insecure-tls) y deja el comando "promql".
# Prometheus NO se instala aqui: lo instalas tu en el paso 3.
# Versiones: las mismas que fija kcna.ps1 en el curso.
HELM_VERSION=v3.19.0
METRICS_SERVER_VERSION=v0.9.0

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

# metrics-server (kubectl top), si no viene instalado
if ! kubectl get deploy metrics-server -n kube-system >/dev/null 2>&1; then
  reintenta kubectl apply -f "https://github.com/kubernetes-sigs/metrics-server/releases/download/${METRICS_SERVER_VERSION}/components.yaml" \
    || fallo "no se pudo instalar metrics-server"
fi
# En kubeadm los certificados del kubelet no los firma la CA del cluster: metrics-server necesita --kubelet-insecure-tls
if ! kubectl get deploy metrics-server -n kube-system -o jsonpath='{.spec.template.spec.containers[0].args}' | grep -q kubelet-insecure-tls; then
  kubectl -n kube-system patch deployment metrics-server --type=json \
    -p '[{"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--kubelet-insecure-tls"}]'
fi

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

touch /tmp/listo
