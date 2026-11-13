#!/bin/bash
# Se ejecuta en segundo plano al abrir el escenario: prepara los nodos como en el curso
# y despliega las apps rotas del modulo 09 con el caso 1 (frontend) ya arreglado.
until kubectl get nodes >/dev/null 2>&1; do sleep 2; done

# controlplane con su taint (las apps van a node01) y node01 con los labels del worker del curso.
kubectl taint nodes controlplane node-role.kubernetes.io/control-plane:NoSchedule --overwrite
kubectl label nodes node01 disktype=ssd zone=zona-a --overwrite
kubectl create namespace lab-09 --dry-run=client -o yaml | kubectl apply -f -

# Espera a que Killercoda copie los manifiestos (como mucho 2 minutos).
for i in $(seq 1 120); do [ -f /root/lab/rotos/06-shop.yaml ] && break; sleep 1; done
sed -i 's/nginx:1.27-alpinee/nginx:1.27-alpine/' /root/lab/rotos/01-frontend.yaml
kubectl apply -f /root/lab/rotos/
kubectl rollout status deploy/frontend -n lab-09 --timeout=180s
touch /tmp/listo
