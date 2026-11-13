#!/bin/bash
# Se ejecuta en segundo plano al abrir el escenario: prepara los nodos, instala metrics-server
# y despliega las apps rotas del modulo 09 con el caso 1 (frontend) ya arreglado.
until kubectl get nodes >/dev/null 2>&1; do sleep 2; done

# controlplane con su taint (las apps van a node01) y node01 con los labels del worker del curso.
kubectl taint nodes controlplane node-role.kubernetes.io/control-plane:NoSchedule --overwrite
kubectl label nodes node01 disktype=ssd zone=zona-a --overwrite
kubectl create namespace lab-09 --dry-run=client -o yaml | kubectl apply -f -

# metrics-server (version fijada en el curso), con --kubelet-insecure-tls para kubeadm. Idempotente.
if ! kubectl get deploy metrics-server -n kube-system >/dev/null 2>&1; then
  kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.9.0/components.yaml
fi
if ! kubectl get deploy metrics-server -n kube-system -o jsonpath='{.spec.template.spec.containers[0].args}' | grep -q kubelet-insecure-tls; then
  kubectl patch deploy metrics-server -n kube-system --type=json \
    -p '[{"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--kubelet-insecure-tls"}]'
fi

# Espera a que Killercoda copie los manifiestos (como mucho 2 minutos).
for i in $(seq 1 120); do [ -f /root/lab/rotos/06-shop.yaml ] && break; sleep 1; done
sed -i 's/nginx:1.27-alpinee/nginx:1.27-alpine/' /root/lab/rotos/01-frontend.yaml
kubectl apply -f /root/lab/rotos/
kubectl rollout status deploy/frontend -n lab-09 --timeout=180s
touch /tmp/listo
