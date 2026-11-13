echo "Preparando el laboratorio (instalando metrics-server, puede tardar uno o dos minutos)..."
while [ ! -f /tmp/listo ]; do sleep 1; done
echo "Esperando a que metrics-server tenga las primeras metricas..."
for i in $(seq 1 90); do
  kubectl top nodes >/dev/null 2>&1 && break
  sleep 2
done
clear
echo "Listo: namespace lab-10 creado y metrics-server instalado. Puedes guardar tus manifiestos en /root/lab"
kubectl top nodes || echo "AVISO: kubectl top nodes aun no responde. Espera un minuto y repitelo."
