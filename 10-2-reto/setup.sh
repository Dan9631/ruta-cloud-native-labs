#!/bin/bash
# Se ejecuta en segundo plano al abrir el escenario: espera al cluster, crea el namespace
# e instala metrics-server (lo necesitan kubectl top y el HPA) si no esta.
until kubectl get nodes >/dev/null 2>&1; do sleep 2; done
kubectl create namespace lab-10 --dry-run=client -o yaml | kubectl apply -f -
mkdir -p /root/lab

# metrics-server: misma version que fija kcna.ps1 en el curso.
MS_VERSION=v0.9.0
if ! kubectl get deployment metrics-server -n kube-system >/dev/null 2>&1; then
  kubectl apply -f "https://github.com/kubernetes-sigs/metrics-server/releases/download/${MS_VERSION}/components.yaml"
fi
# En kubeadm los certificados del kubelet no estan firmados para sus IPs: hace falta --kubelet-insecure-tls.
if ! kubectl get deployment metrics-server -n kube-system -o jsonpath='{.spec.template.spec.containers[0].args}' | grep -q kubelet-insecure-tls; then
  kubectl patch deployment metrics-server -n kube-system --type=json \
    -p '[{"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--kubelet-insecure-tls"}]'
fi
kubectl rollout status deployment/metrics-server -n kube-system --timeout=240s

touch /tmp/listo
