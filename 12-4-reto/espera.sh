echo "Preparando el laboratorio (namespace y helm)..."
while [ ! -f /tmp/listo ]; do sleep 1; done
clear
echo "Listo: namespace lab-12 creado. Kustomize en /root/lab/kustomize y el chart en /root/lab/helm"
kubectl get nodes
