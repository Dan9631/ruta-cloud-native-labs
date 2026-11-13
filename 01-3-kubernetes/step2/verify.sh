#!/bin/bash
# El Pod web-propia de lab-01 usa la imagen propia, esta listo y sirve la pagina v1.
ns=lab-01
estado=$(kubectl get pod web-propia -n $ns -o jsonpath='{.spec.containers[0].image}/{.status.containerStatuses[0].ready}' 2>/dev/null)
[ "$estado" = "localhost/kcna-web:1.0/true" ] \
  || { echo "Falta el Pod web-propia en $ns con localhost/kcna-web:1.0 y listo (ahora: '$estado')"; exit 1; }
kubectl exec web-propia -n $ns -- wget -qO- http://localhost/ 2>/dev/null | grep -q 'KCNA v1' \
  || { echo "El Pod web-propia no sirve la pagina de tu imagen"; exit 1; }
