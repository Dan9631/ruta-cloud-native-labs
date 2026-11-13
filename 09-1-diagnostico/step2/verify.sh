#!/bin/bash
# frontend arreglado: imagen correcta, 2 replicas actualizadas y listas, y su Service con endpoints listos.
ns=lab-09
img=$(kubectl get deploy frontend -n $ns -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)
[ "$img" = "nginx:1.27-alpine" ] || { echo "El Deployment frontend todavia usa la imagen '$img': revisa el tag"; exit 1; }
estado=$(kubectl get deploy frontend -n $ns -o jsonpath='{.spec.replicas}/{.status.updatedReplicas}/{.status.readyReplicas}' 2>/dev/null)
[ "$estado" = "2/2/2" ] || { echo "frontend todavia no tiene sus 2 replicas actualizadas y listas (ahora: '$estado'). Espera al rollout"; exit 1; }
listos=$(kubectl get endpointslices -n $ns -l kubernetes.io/service-name=frontend -o jsonpath='{range .items[*]}{range .endpoints[*]}{.conditions.ready}{"\n"}{end}{end}' 2>/dev/null | grep -c '^true$')
[ "$listos" -ge 2 ] || { echo "El Service frontend todavia no tiene 2 endpoints listos (ahora: $listos)"; exit 1; }
