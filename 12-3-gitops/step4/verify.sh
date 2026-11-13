#!/bin/bash
# Hubo drift y Argo CD lo deshizo: el spec de gitops-web cambio (generation >= 3: escalado a mano
# y vuelta atras), vuelve a 2 replicas, y el Service se recreo despues que el Deployment.
ns=lab-12
gen=$(kubectl get deploy gitops-web -n $ns -o jsonpath='{.metadata.generation}' 2>/dev/null)
[ "${gen:-0}" -ge 3 ] || { echo "Falta provocar el drift: escala gitops-web a 5 replicas y borra su Service"; exit 1; }
r=$(kubectl get deploy gitops-web -n $ns -o jsonpath='{.spec.replicas}/{.status.readyReplicas}' 2>/dev/null)
[ "$r" = "2/2" ] || { echo "gitops-web todavia no ha vuelto a 2 replicas listas (ahora: '$r'). Espera unos segundos"; exit 1; }
tsvc=$(kubectl get svc gitops-web -n $ns -o jsonpath='{.metadata.creationTimestamp}' 2>/dev/null)
[ -n "$tsvc" ] || { echo "El Service gitops-web todavia no existe: espera a que Argo CD lo recree"; exit 1; }
tdep=$(kubectl get deploy gitops-web -n $ns -o jsonpath='{.metadata.creationTimestamp}')
[[ "$tsvc" > "$tdep" ]] || { echo "Falta borrar el Service gitops-web para ver como Argo CD lo recrea"; exit 1; }
e=$(kubectl get application gitops-demo -n argocd -o jsonpath='{.status.sync.status}' 2>/dev/null)
[ "$e" = "Synced" ] || { echo "gitops-demo todavia no ha vuelto a Synced (ahora: '$e')"; exit 1; }
