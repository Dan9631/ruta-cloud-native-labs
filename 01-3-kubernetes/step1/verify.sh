#!/bin/bash
# La imagen localhost/kcna-web:1.0 existe en Podman y tambien en el containerd del nodo (lo que ve el kubelet).
podman image exists localhost/kcna-web:1.0 \
  || { echo "Falta la imagen localhost/kcna-web:1.0 en Podman: ejecuta el podman build en /root/lab"; exit 1; }
crictl images 2>/dev/null | grep -qE '^localhost/kcna-web +1\.0 ' \
  || { echo "containerd no tiene localhost/kcna-web:1.0: haz podman save y ctr -n k8s.io images import"; exit 1; }
