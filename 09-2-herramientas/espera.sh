echo "Preparando el laboratorio (despliega las apps rotas e instala metrics-server)..."
while [ ! -f /tmp/listo ]; do sleep 1; done
clear
echo "Listo: apps del modulo 09 desplegadas en lab-09 (frontend ya arreglado). Manifiestos en /root/lab/rotos"
kubectl get nodes
kubectl get pods -n lab-09
