echo "Preparando el laboratorio: instalando Prometheus con Helm (de 2 a 5 minutos)..."
while [ ! -f /tmp/listo ] && [ ! -f /tmp/fallo ]; do sleep 2; done
clear
if [ -f /tmp/fallo ]; then
  echo "AVISO: la preparacion fallo: $(cat /tmp/fallo). Revisa /var/log/killercoda y recarga el escenario."
else
  echo "Listo: Prometheus instalado en el namespace lab-11. Los manifiestos estan en /root/lab"
fi
kubectl get nodes
kubectl get pods -n lab-11
