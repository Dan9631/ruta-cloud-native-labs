echo "Preparando el laboratorio (namespace y helm)..."
while [ ! -f /tmp/listo ]; do sleep 1; done
clear
echo "Listo: namespace lab-12 creado. El chart esta en /root/lab/helm"
helm version --short
kubectl get nodes
