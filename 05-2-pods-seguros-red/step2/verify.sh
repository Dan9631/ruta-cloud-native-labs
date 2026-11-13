#!/bin/bash
# lab-05 aplica restricted (enforce y warn), pod-privilegiado no existe y web-inseguro existe pero sin Pods.
ns=$(kubectl get ns lab-05 -o jsonpath='{.metadata.labels.pod-security\.kubernetes\.io/enforce}/{.metadata.labels.pod-security\.kubernetes\.io/warn}' 2>/dev/null)
[ "$ns" = "restricted/restricted" ] || { echo "El namespace lab-05 debe tener los labels enforce=restricted y warn=restricted (ahora: '$ns')"; exit 1; }
if kubectl get pod pod-privilegiado -n lab-05 >/dev/null 2>&1; then echo "pod-privilegiado no deberia existir: borralo y vuelve a intentar crearlo con el perfil restricted aplicado"; exit 1; fi
kubectl get deploy web-inseguro -n lab-05 >/dev/null 2>&1 || { echo "Falta el Deployment web-inseguro: crealo para ver como lo bloquea PSA"; exit 1; }
listos=$(kubectl get deploy web-inseguro -n lab-05 -o jsonpath='{.status.readyReplicas}' 2>/dev/null)
[ "${listos:-0}" -eq 0 ] || { echo "web-inseguro tiene Pods listos: el perfil restricted deberia impedirlos"; exit 1; }
