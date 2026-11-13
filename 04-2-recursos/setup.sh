#!/bin/bash
# Se ejecuta en segundo plano al abrir el escenario.
# Prepara dos nodos programables con las labels del curso:
#   controlplane -> disktype=ssd, zone=zona-a
#   node01       -> disktype=hdd, zone=zona-b
# e instala metrics-server (para kubectl top) si no esta.
until kubectl get nodes >/dev/null 2>&1; do sleep 2; done
until [ "$(kubectl get nodes --no-headers 2>/dev/null | wc -l)" -ge 2 ]; do sleep 2; done
kubectl wait --for=condition=Ready node --all --timeout=300s

# Quita el taint de control-plane solo si esta puesto (idempotente).
if kubectl get node controlplane -o jsonpath='{.spec.taints[*].key}' | grep -qw 'node-role.kubernetes.io/control-plane'; then
  kubectl taint nodes controlplane node-role.kubernetes.io/control-plane:NoSchedule-
fi

kubectl label nodes controlplane disktype=ssd zone=zona-a --overwrite
kubectl label nodes node01 disktype=hdd zone=zona-b --overwrite

kubectl create namespace lab-04 --dry-run=client -o yaml | kubectl apply -f -
mkdir -p /root/lab

# metrics-server: misma version que fija el curso; en kubeadm necesita --kubelet-insecure-tls.
# No se espera a que este listo: solo lo usa un comando opcional (kubectl top).
if ! kubectl get deploy metrics-server -n kube-system >/dev/null 2>&1; then
  kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.9.0/components.yaml
fi
args=$(kubectl -n kube-system get deploy metrics-server -o jsonpath='{.spec.template.spec.containers[0].args}' 2>/dev/null)
if [ -n "$args" ] && ! echo "$args" | grep -q kubelet-insecure-tls; then
  kubectl -n kube-system patch deploy metrics-server --type=json \
    -p '[{"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--kubelet-insecure-tls"}]'
fi

touch /tmp/listo
