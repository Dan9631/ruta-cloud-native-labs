#!/bin/bash
# El mirror pod estatico-node01 existe en lab-02, corre en node01, esta Running y viene de un archivo.
estado=$(kubectl get pod estatico-node01 -n lab-02 -o jsonpath='{.spec.nodeName}/{.status.phase}/{.metadata.ownerReferences[0].kind}/{.metadata.annotations.kubernetes\.io/config\.source}' 2>/dev/null)
[ "$estado" = "node01/Running/Node/file" ] || { echo "Falta el static pod estatico-node01 en lab-02, Running en node01: copia /root/lab/estatico.yaml a /etc/kubernetes/manifests de node01 (ahora: '$estado')"; exit 1; }
