#!/bin/bash
# prod-web se escalo a mano (su spec cambio al menos dos veces desde que se creo: generation >= 3)
# y despues se reconcilio con el overlay: vuelve a 3 replicas listas.
ns=lab-12
gen=$(kubectl get deploy prod-web -n $ns -o jsonpath='{.metadata.generation}' 2>/dev/null)
[ "${gen:-0}" -ge 3 ] || { echo "Falta provocar el drift: escala prod-web a 5 replicas y despues vuelve a aplicar el overlay prod"; exit 1; }
estado=$(kubectl get deploy prod-web -n $ns -o jsonpath='{.spec.replicas}/{.status.readyReplicas}' 2>/dev/null)
[ "$estado" = "3/3" ] || { echo "prod-web debe volver a 3 replicas listas con kubectl apply -k del overlay prod (ahora: '$estado')"; exit 1; }
