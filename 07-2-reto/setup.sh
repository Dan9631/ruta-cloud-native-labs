#!/bin/bash
# Se ejecuta en segundo plano al abrir el escenario: espera al cluster, crea el namespace del laboratorio,
# instala los CRD de Gateway API y Traefik (con el Gateway "traefik-gateway"), publicado en el NodePort 30080,
# y despliega whoami-v1 y whoami-v2 con sus Services, que el reto da por hechos.
# Versiones: las mismas que fija kcna.ps1 en el curso.
GATEWAY_API_VERSION=v1.6.3
TRAEFIK_CHART_VERSION=42.1.3
HELM_VERSION=v3.19.0

reintenta() { for i in 1 2 3 4 5; do "$@" && return 0; sleep 5; done; return 1; }

until kubectl get nodes >/dev/null 2>&1; do sleep 2; done
kubectl create namespace lab-07 --dry-run=client -o yaml | kubectl apply -f -
mkdir -p /root/lab

# helm, si no viene instalado
if ! command -v helm >/dev/null 2>&1; then
  reintenta curl -fsSL "https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz" -o /tmp/helm.tgz
  tar -xzf /tmp/helm.tgz -C /tmp linux-amd64/helm && install -m 0755 /tmp/linux-amd64/helm /usr/local/bin/helm
fi

# CRD de Gateway API (canal Standard)
reintenta kubectl apply --server-side -f "https://github.com/kubernetes-sigs/gateway-api/releases/download/${GATEWAY_API_VERSION}/standard-install.yaml"

# Traefik: mismos valores que cluster/traefik-values.yaml del curso, salvo la publicacion:
# en kind usa hostPort 80 en el control-plane; aqui un Service NodePort (30080) y recursos modestos.
cat > /root/traefik-values.yaml <<'EOF'
ports:
  web:
    nodePort: 30080
service:
  type: NodePort
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
  enabled: true
  listeners:
    web:
      port: 8000
      protocol: HTTP
      namespacePolicy:
        from: All
EOF
reintenta helm repo add traefik https://traefik.github.io/charts --force-update
reintenta helm repo update traefik
reintenta helm upgrade --install traefik traefik/traefik --version "$TRAEFIK_CHART_VERSION" -n traefik --create-namespace \
  -f /root/traefik-values.yaml --wait --timeout 5m
kubectl wait --for=condition=Programmed gateway/traefik-gateway -n traefik --timeout=180s

# whoami v1 y v2 del laboratorio guiado (labs/07-service-mesh-microservicios/02-whoami-v1-v2.yaml)
cat > /root/lab/02-whoami-v1-v2.yaml <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: whoami-v1
  namespace: lab-07
spec:
  replicas: 2
  selector:
    matchLabels: { app: whoami, version: v1 }
  template:
    metadata:
      labels: { app: whoami, version: v1 }
    spec:
      containers:
        - name: whoami
          image: traefik/whoami:v1.11
          env:
            - name: WHOAMI_NAME
              value: v1
          ports:
            - containerPort: 80
          resources:
            requests: { cpu: 10m, memory: 16Mi }
            limits:   { cpu: 100m, memory: 64Mi }
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: whoami-v2
  namespace: lab-07
spec:
  replicas: 1
  selector:
    matchLabels: { app: whoami, version: v2 }
  template:
    metadata:
      labels: { app: whoami, version: v2 }
    spec:
      containers:
        - name: whoami
          image: traefik/whoami:v1.11
          env:
            - name: WHOAMI_NAME
              value: v2
          ports:
            - containerPort: 80
          resources:
            requests: { cpu: 10m, memory: 16Mi }
            limits:   { cpu: 100m, memory: 64Mi }
---
apiVersion: v1
kind: Service
metadata:
  name: whoami-v1
  namespace: lab-07
spec:
  selector: { app: whoami, version: v1 }
  ports:
    - port: 80
      targetPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: whoami-v2
  namespace: lab-07
spec:
  selector: { app: whoami, version: v2 }
  ports:
    - port: 80
      targetPort: 80
EOF
reintenta kubectl apply -f /root/lab/02-whoami-v1-v2.yaml
kubectl rollout status deploy/whoami-v1 -n lab-07 --timeout=180s
kubectl rollout status deploy/whoami-v2 -n lab-07 --timeout=180s

# URL del Gateway para las terminales nuevas
ip=$(kubectl get node controlplane -o jsonpath='{.status.addresses[?(@.type=="InternalIP")].address}')
grep -q 'export GW=' /root/.bashrc || echo "export GW=http://${ip}:30080" >> /root/.bashrc

touch /tmp/listo
