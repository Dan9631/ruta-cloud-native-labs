echo "Preparando el laboratorio..."
while [ ! -f /tmp/listo ]; do sleep 1; done
clear
echo "Listo: namespace lab-06 creado. Los manifiestos estan en /root/lab"
kubectl get nodes
