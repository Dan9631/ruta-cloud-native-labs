#!/bin/bash
# gitops-web usa nginx:1.28-alpine porque Argo CD sincronizo un commit nuevo (no un kubectl set image,
# que el selfHeal desharia): la revision sincronizada ya no es la del primer sync.
ns=lab-12
img=$(kubectl get deploy gitops-web -n $ns -o jsonpath='{.spec.template.spec.containers[0].image}/{.status.updatedReplicas}/{.status.readyReplicas}' 2>/dev/null)
[ "$img" = "nginx:1.28-alpine/2/2" ] || { echo "gitops-web debe tener 2 replicas listas con nginx:1.28-alpine, cambiadas con un commit (ahora: '$img')"; exit 1; }
actual=$(kubectl get application gitops-demo -n argocd -o jsonpath='{.status.sync.revision}' 2>/dev/null)
primera=$(kubectl get application gitops-demo -n argocd -o jsonpath='{.status.history[0].revision}' 2>/dev/null)
[ -n "$actual" ] && [ "$actual" != "$primera" ] || { echo "Argo CD todavia no ha sincronizado un commit nuevo: haz push y fuerza el refresh"; exit 1; }
e=$(kubectl get application gitops-demo -n argocd -o jsonpath='{.status.sync.status}/{.status.health.status}' 2>/dev/null)
[ "$e" = "Synced/Healthy" ] || { echo "gitops-demo todavia no esta Synced/Healthy (ahora: '$e')"; exit 1; }
