#!/bin/bash
# pod-root y pod-seguro estan Running; pod-seguro corre como UID 1000 con raiz de solo lectura.
root=$(kubectl get pod pod-root -n lab-05 -o jsonpath='{.status.phase}' 2>/dev/null)
[ "$root" = "Running" ] || { echo "Falta el Pod pod-root en Running en lab-05 (ahora: '$root')"; exit 1; }
seguro=$(kubectl get pod pod-seguro -n lab-05 -o jsonpath='{.status.phase}/{.spec.securityContext.runAsUser}/{.spec.containers[0].securityContext.readOnlyRootFilesystem}' 2>/dev/null)
[ "$seguro" = "Running/1000/true" ] || { echo "Falta el Pod pod-seguro en Running, con runAsUser 1000 y readOnlyRootFilesystem (ahora: '$seguro')"; exit 1; }
