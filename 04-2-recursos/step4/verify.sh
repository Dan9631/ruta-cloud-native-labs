#!/bin/bash
# El archivo del static Pod esta en /etc/kubernetes/manifests de controlplane y su mirror pod corre.
ns=lab-04
[ -f /etc/kubernetes/manifests/lab-04-estatico.yaml ] \
  || { echo "Falta el archivo /etc/kubernetes/manifests/lab-04-estatico.yaml en controlplane"; exit 1; }
estado=$(kubectl get pod estatico-controlplane -n $ns -o jsonpath='{.status.phase}/{.metadata.ownerReferences[0].kind}' 2>/dev/null)
[ "$estado" = "Running/Node" ] || { echo "Falta el Pod estatico-controlplane Running y propiedad del Node (ahora: '$estado'). Espera unos segundos"; exit 1; }
