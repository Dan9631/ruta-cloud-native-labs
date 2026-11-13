echo "Preparando el laboratorio..."
while [ ! -f /tmp/listo ]; do sleep 1; done
clear
echo "Listo: namespace lab-04 creado y nodos etiquetados. Los manifiestos estan en /root/lab"
kubectl get nodes -L disktype,zone
