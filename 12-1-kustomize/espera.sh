echo "Preparando el laboratorio..."
while [ ! -f /tmp/listo ]; do sleep 1; done
clear
echo "Listo: namespace lab-12 creado. Los archivos del lab estan en /root/lab"
kubectl get nodes
