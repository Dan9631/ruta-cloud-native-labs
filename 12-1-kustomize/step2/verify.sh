#!/bin/bash
# dev-web (1 replica, 1.27) y prod-web (3 replicas, 1.28, requests del patch) listos en lab-12,
# con Services que seleccionan solo su entorno.
ns=lab-12
dev=$(kubectl get deploy dev-web -n $ns -o jsonpath='{.status.readyReplicas}/{.spec.template.spec.containers[0].image}' 2>/dev/null)
[ "$dev" = "1/nginx:1.27-alpine" ] || { echo "Falta dev-web con 1 replica lista y nginx:1.27-alpine (ahora: '$dev'). Aplica el overlay dev"; exit 1; }
prod=$(kubectl get deploy prod-web -n $ns -o jsonpath='{.status.readyReplicas}/{.spec.template.spec.containers[0].image}/{.spec.template.spec.containers[0].resources.requests.cpu}' 2>/dev/null)
[ "$prod" = "3/nginx:1.28-alpine/50m" ] || { echo "Falta prod-web con 3 replicas listas, nginx:1.28-alpine y requests de 50m (ahora: '$prod'). Aplica el overlay prod"; exit 1; }
sel=$(kubectl get svc dev-web prod-web -n $ns -o jsonpath='{.items[*].spec.selector.env}' 2>/dev/null)
[ "$sel" = "dev prod" ] || { echo "Los Services dev-web y prod-web deben seleccionar env=dev y env=prod (ahora: '$sel')"; exit 1; }
