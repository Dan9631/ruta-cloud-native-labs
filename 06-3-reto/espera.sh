echo "Preparando el laboratorio: se instalan Gateway API y Traefik (tarda 2-4 minutos)..."
while [ ! -f /tmp/listo ]; do sleep 2; printf '.'; done
clear
if [ -f /tmp/setup-fallo ]; then
  echo "AVISO: la preparacion tuvo problemas (detalles en /var/log/killercoda):"
  cat /tmp/setup-fallo
  echo
fi
echo "Listo: Traefik escucha en el NodePort 30800 y el namespace lab-06 esta creado."
kubectl get nodes
