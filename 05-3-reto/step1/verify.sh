#!/bin/bash
# Reto del modulo 05: RBAC de minimo privilegio, PSA restricted, Pod endurecido y NetworkPolicy.
ns=lab-05
sa=system:serviceaccount:lab-05:despliegues
falta() { echo "FALTA: $1"; exit 1; }
puede() { [ "$(kubectl auth can-i "$@" --as=$sa 2>/dev/null)" = "yes" ]; }

# 1. ServiceAccount que gestiona Deployments solo en lab-05
kubectl get serviceaccount despliegues -n $ns >/dev/null 2>&1 || falta "no existe la ServiceAccount 'despliegues' en $ns"
puede create deployments.apps -n $ns && puede delete deployments.apps -n $ns \
  || falta "'despliegues' debe poder crear y borrar deployments en $ns (Role y RoleBinding gestor-deploy, grupo apps)"
puede get secrets -n $ns && falta "'despliegues' no debe poder leer secrets (minimo privilegio)"
puede create deployments.apps -n default && falta "'despliegues' no debe poder crear deployments fuera de $ns"

# 2. Listar nodos (no borrarlos) mediante un ClusterRoleBinding lab-05-*
kubectl get clusterrolebindings -o jsonpath='{range .items[*]}{.metadata.name}{" "}{range .subjects[*]}{.kind}/{.namespace}/{.name}{" "}{end}{"\n"}{end}' \
  | grep -E '^lab-05-' | grep -q ' ServiceAccount/lab-05/despliegues ' \
  || falta "no hay un ClusterRoleBinding 'lab-05-...' que una la ServiceAccount 'despliegues'"
puede list nodes || falta "'despliegues' debe poder listar nodos"
puede delete nodes && falta "'despliegues' no debe poder borrar nodos"

# 3. Pod Security Admission restricted
[ "$(kubectl get ns $ns -o jsonpath='{.metadata.labels.pod-security\.kubernetes\.io/enforce}')" = "restricted" ] \
  || falta "el namespace $ns debe tener el label pod-security.kubernetes.io/enforce=restricted"

# 4. Pod app-segura Running, UID 2000 y raiz de solo lectura
kubectl get pod app-segura -n $ns >/dev/null 2>&1 || falta "no existe el Pod 'app-segura' en $ns"
fase=$(kubectl get pod app-segura -n $ns -o jsonpath='{.status.phase}')
[ "$fase" = "Running" ] || falta "el Pod 'app-segura' debe estar Running (ahora: '$fase')"
uid=$(kubectl get pod app-segura -n $ns -o jsonpath='{.spec.containers[0].securityContext.runAsUser}')
[ -n "$uid" ] || uid=$(kubectl get pod app-segura -n $ns -o jsonpath='{.spec.securityContext.runAsUser}')
[ "$uid" = "2000" ] || falta "el Pod 'app-segura' debe correr con runAsUser 2000 (ahora: '$uid')"
[ "$(kubectl get pod app-segura -n $ns -o jsonpath='{.spec.containers[0].securityContext.readOnlyRootFilesystem}')" = "true" ] \
  || falta "el contenedor de 'app-segura' debe tener readOnlyRootFilesystem: true"

# 5. NetworkPolicy db-solo-api
kubectl get networkpolicy db-solo-api -n $ns >/dev/null 2>&1 || falta "no existe la NetworkPolicy 'db-solo-api' en $ns"
reglas=$(kubectl get networkpolicy db-solo-api -n $ns -o jsonpath='{range .spec.ingress[*]}R{end}')
np=$(kubectl get networkpolicy db-solo-api -n $ns -o jsonpath='{.spec.podSelector.matchLabels.app}/{.spec.ingress[0].from[0].podSelector.matchLabels.app}/{.spec.ingress[0].ports[0].protocol}/{.spec.ingress[0].ports[0].port}')
[ "$reglas" = "R" ] && [ "$np" = "db/api/TCP/6379" ] \
  || falta "la NetworkPolicy 'db-solo-api' debe proteger app=db con una sola regla: desde app=api, puerto TCP 6379 (ahora: '$np')"

echo "Reto superado"
