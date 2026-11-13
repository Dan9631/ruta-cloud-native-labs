#!/bin/bash
# El Pod cliente (busybox) esta Running en lab-09 y desde el llega el Service frontend.
ns=lab-09
fase=$(kubectl get pod cliente -n $ns -o jsonpath='{.status.phase}' 2>/dev/null)
[ "$fase" = "Running" ] || { echo "Falta el Pod 'cliente' en $ns en Running (ahora: '$fase')"; exit 1; }
kubectl exec -n $ns cliente -- wget -qO- -T 3 http://frontend 2>/dev/null | grep -qi nginx \
  || { echo "Desde el Pod cliente no responde http://frontend: revisa que frontend este arreglado"; exit 1; }
