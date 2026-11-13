echo "Preparando el laboratorio: se instalan Gateway API y Traefik (tarda 2-4 minutos)..."
while [ ! -f /tmp/listo ]; do sleep 2; printf '.'; done
clear
if [ -f /tmp/setup-fallo ]; then
  echo "AVISO: la preparacion tuvo problemas (detalles en /var/log/killercoda):"
  cat /tmp/setup-fallo
  echo
fi
echo "Listo: Traefik instalado en el namespace traefik y whoami desplegado en lab-06."
echo "Los manifiestos estan en /root/lab"
kubectl get nodes
