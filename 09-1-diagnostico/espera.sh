echo "Preparando el laboratorio..."
while [ ! -f /tmp/listo ]; do sleep 1; done
clear
echo "Listo: namespace lab-09 creado. Los manifiestos rotos estan en /root/lab/rotos"
kubectl get nodes
