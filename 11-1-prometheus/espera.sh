echo "Preparando el laboratorio (helm y metrics-server)..."
while [ ! -f /tmp/listo ] && [ ! -f /tmp/fallo ]; do sleep 1; done
clear
if [ -f /tmp/fallo ]; then
  echo "AVISO: la preparacion fallo: $(cat /tmp/fallo). Revisa /var/log/killercoda y recarga el escenario."
else
  echo "Listo: namespace lab-11 creado, helm y metrics-server instalados. Los manifiestos estan en /root/lab"
fi
kubectl get nodes
