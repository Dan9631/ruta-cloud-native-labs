#!/bin/bash
# Reto del modulo 01: imagen propia v2 construida con Podman, importada en containerd y ejecutada como Pod en lab-01.
ns=lab-01
falta() { echo "FALTA: $1"; exit 1; }

podman image exists localhost/kcna-web:2.0 \
  || falta "la imagen localhost/kcna-web:2.0 en Podman (podman build -t kcna-web:2.0 .)"

v=$(podman image inspect localhost/kcna-web:2.0 --format '{{index .Labels "org.opencontainers.image.version"}}' 2>/dev/null)
[ "$v" = "2.0" ] \
  || falta "la etiqueta OCI org.opencontainers.image.version=2.0 en la imagen 2.0 (ahora: '$v')"

crictl images 2>/dev/null | grep -qE '^localhost/kcna-web +2\.0 ' \
  || falta "la imagen localhost/kcna-web:2.0 en el containerd del nodo (podman save + ctr -n k8s.io images import)"

kubectl get pod web-v2 -n $ns >/dev/null 2>&1 || falta "el Pod 'web-v2' en $ns"

[ "$(kubectl get pod web-v2 -n $ns -o jsonpath='{.spec.containers[0].image}')" = "localhost/kcna-web:2.0" ] \
  || falta "el Pod 'web-v2' debe usar la imagen localhost/kcna-web:2.0"

[ "$(kubectl get pod web-v2 -n $ns -o jsonpath='{.metadata.labels.app}/{.metadata.labels.version}')" = "kcna-web/v2" ] \
  || falta "el Pod 'web-v2' debe tener los labels app=kcna-web y version=v2"

[ "$(kubectl get pod web-v2 -n $ns -o jsonpath='{.status.containerStatuses[0].ready}')" = "true" ] \
  || falta "el Pod 'web-v2' debe estar Running y listo (si esta en ImagePullBackOff, importa la imagen y vuelve a crearlo)"

kubectl exec web-v2 -n $ns -- wget -qO- http://localhost/ 2>/dev/null | grep -q 'v2' \
  || falta "la pagina que sirve 'web-v2' debe contener el texto 'v2'"

echo "Reto superado"
