echo "Preparando el laboratorio: instala Gateway API, Traefik y whoami v1/v2 (1-3 minutos)..."
while [ ! -f /tmp/listo ]; do sleep 1; done
GW=http://$(kubectl get node controlplane -o jsonpath='{.status.addresses[?(@.type=="InternalIP")].address}'):30080
n=0
until [ "$(curl -s -o /dev/null -m 3 -w '%{http_code}' "$GW/")" = "404" ] || [ $n -ge 90 ]; do n=$((n+1)); sleep 2; done
clear
if [ $n -ge 90 ]; then
  echo "AVISO: Traefik todavia no responde en $GW. Revisa: kubectl get pods -n traefik (registro en /var/log/killercoda)"
else
  echo "Listo: namespace lab-07 con whoami-v1 y whoami-v2, y Traefik responde en $GW"
fi
kubectl get nodes
kubectl get deploy,svc -n lab-07
