#!/bin/bash
# web-ssd con 3 replicas listas, todas en controlplane (disktype=ssd), e 'imposible' Pending sin nodo.
ns=lab-04
listo=$(kubectl get deploy web-ssd -n $ns -o jsonpath='{.status.readyReplicas}' 2>/dev/null)
[ "$listo" = "3" ] || { echo "Falta el Deployment web-ssd con 3 replicas listas (ahora: '${listo:-0}')"; exit 1; }
otros=$(kubectl get pods -n $ns -l app=web-ssd -o jsonpath='{range .items[*]}{.spec.nodeName}{"\n"}{end}' | grep -vcx controlplane)
[ "$otros" = "0" ] || { echo "Todas las replicas de web-ssd deberian estar en controlplane, el nodo disktype=ssd"; exit 1; }
estado=$(kubectl get pod imposible -n $ns -o jsonpath='{.status.phase}/{.spec.nodeName}' 2>/dev/null)
[ "$estado" = "Pending/" ] || { echo "Falta el Pod imposible en Pending y sin nodo asignado (ahora: '$estado')"; exit 1; }
