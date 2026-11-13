#!/bin/bash
# El Pod sin-cargar de lab-01 pide localhost/kcna-web:9.9 y esta esperando por un fallo de descarga.
ns=lab-01
img=$(kubectl get pod sin-cargar -n $ns -o jsonpath='{.spec.containers[0].image}' 2>/dev/null)
[ "$img" = "localhost/kcna-web:9.9" ] \
  || { echo "Falta el Pod sin-cargar en $ns con la imagen localhost/kcna-web:9.9 (ahora: '$img')"; exit 1; }
motivo=$(kubectl get pod sin-cargar -n $ns -o jsonpath='{.status.containerStatuses[0].state.waiting.reason}' 2>/dev/null)
case "$motivo" in
  ErrImagePull|ImagePullBackOff) exit 0 ;;
  *) echo "El Pod sin-cargar todavia no esta en ErrImagePull ni ImagePullBackOff (ahora: '$motivo'): espera unos segundos"; exit 1 ;;
esac
