#!/bin/bash
# Se ejecuta en segundo plano al abrir el escenario. Prepara lo que en el curso hace 'kcna.ps1 up':
#   - CRDs de Gateway API y Traefik (Ingress Controller + Gateway API) con las versiones del curso,
#     expuesto con un Service NodePort (web -> 30800) porque kubeadm no tiene LoadBalancer.
#   - Namespace lab-06 vacio: el reto se construye desde cero.
# Si algo falla, lo anota en /tmp/setup-fallo y espera.sh lo muestra.

GATEWAY_API_VERSION=v1.6.3
TRAEFIK_CHART_VERSION=42.1.3
HELM_VERSION=v3.19.0
TRAEFIK_NODEPORT=30800

fallo() { echo "ERROR: $1" | tee -a /tmp/setup-fallo; }
reintenta() { for _ in 1 2 3 4 5; do "$@" && return 0; sleep 5; done; return 1; }

until kubectl get nodes >/dev/null 2>&1; do sleep 2; done
kubectl taint nodes controlplane node-role.kubernetes.io/control-plane:NoSchedule- >/dev/null 2>&1 || true
kubectl create namespace lab-06 --dry-run=client -o yaml | kubectl apply -f -
mkdir -p /root/lab

# --- helm (solo si no esta) ---
if ! command -v helm >/dev/null 2>&1; then
  case "$(uname -m)" in aarch64|arm64) arch=arm64 ;; *) arch=amd64 ;; esac
  if reintenta sh -c "curl -fsSL https://get.helm.sh/helm-$HELM_VERSION-linux-$arch.tar.gz | tar -xz -C /tmp"; then
    install -m 755 "/tmp/linux-$arch/helm" /usr/local/bin/helm
  else
    fallo "no se pudo instalar helm $HELM_VERSION"
  fi
fi

# --- CRDs de Gateway API ---
reintenta kubectl apply --server-side -f "https://github.com/kubernetes-sigs/gateway-api/releases/download/$GATEWAY_API_VERSION/standard-install.yaml" \
  || fallo "no se pudieron instalar los CRDs de Gateway API $GATEWAY_API_VERSION"
kubectl wait --for condition=Established crd/gatewayclasses.gateway.networking.k8s.io crd/gateways.gateway.networking.k8s.io crd/httproutes.gateway.networking.k8s.io --timeout=90s

# --- Traefik: valores del curso (cluster/traefik-values.yaml) adaptados a kubeadm ---
# En kind escucha con hostPort 80/443 en el control-plane; aqui se expone con NodePort.
cat > /root/traefik-values.yaml <<EOF
service:
  type: NodePort
ports:
  web:
    nodePort: $TRAEFIK_NODEPORT
  websecure:
    nodePort: 30443
resources:
  requests:
    cpu: 50m
    memory: 64Mi
  limits:
    memory: 256Mi
ingressClass:
  enabled: true
  isDefaultClass: true
providers:
  kubernetesIngress:
    enabled: true
  kubernetesGateway:
    enabled: true
gateway:
  # Gateway "traefik-gateway" en el namespace traefik, listener HTTP en el puerto 8000 del Pod
  enabled: true
  listeners:
    web:
      port: 8000
      protocol: HTTP
      namespacePolicy:
        from: All
EOF
reintenta helm repo add traefik https://traefik.github.io/charts --force-update \
  || fallo "no se pudo anadir el repositorio de charts de Traefik"
helm upgrade --install traefik traefik/traefik --version "$TRAEFIK_CHART_VERSION" -n traefik --create-namespace \
  -f /root/traefik-values.yaml --wait --timeout 5m \
  || fallo "helm no pudo instalar Traefik $TRAEFIK_CHART_VERSION"

# --- Esperar a que todo responda ---
kubectl wait --for=condition=Programmed gateway/traefik-gateway -n traefik --timeout=120s \
  || fallo "el Gateway traefik-gateway no quedo Programmed"
ip=$(kubectl get node controlplane -o jsonpath='{.status.addresses[?(@.type=="InternalIP")].address}')
listo=no
for _ in $(seq 1 60); do
  # Sin rutas, Traefik responde 404: eso basta para saber que escucha en el NodePort.
  [ "$(curl -s -o /dev/null -w '%{http_code}' --max-time 3 "http://$ip:$TRAEFIK_NODEPORT/")" = "404" ] && { listo=si; break; }
  sleep 2
done
[ "$listo" = "si" ] || fallo "Traefik no responde en http://$ip:$TRAEFIK_NODEPORT"

touch /tmp/listo
