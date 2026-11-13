echo "Preparando el laboratorio..."
while [ ! -f /tmp/listo ]; do sleep 1; done
clear
if command -v podman >/dev/null 2>&1; then
  echo "Listo: Podman instalado y las imagenes base descargadas."
  podman --version
  podman images
else
  echo "ERROR: Podman no esta disponible. Revisa /var/log/killercoda"
fi
