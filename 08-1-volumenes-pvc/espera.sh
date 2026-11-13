echo "Preparando el laboratorio (aprovisionador de volumenes y StorageClass)..."
while [ ! -f /tmp/listo ]; do sleep 1; done
clear
echo "Listo: namespace lab-08 creado. Los manifiestos estan en /root/lab"
kubectl get nodes
kubectl get sc
