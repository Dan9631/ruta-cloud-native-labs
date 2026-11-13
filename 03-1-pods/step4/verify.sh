#!/bin/bash
# Los tres Pods existen: uno Succeeded, uno Failed y el tercero con al menos un reinicio.
ok=$(kubectl get pod termina-ok -n lab-03 -o jsonpath='{.status.phase}' 2>/dev/null)
mal=$(kubectl get pod termina-error -n lab-03 -o jsonpath='{.status.phase}' 2>/dev/null)
reinicios=$(kubectl get pod reinicia-siempre -n lab-03 -o jsonpath='{.status.containerStatuses[0].restartCount}' 2>/dev/null)
[ "$ok" = "Succeeded" ] || { echo "termina-ok deberia estar en Succeeded (ahora: '$ok')"; exit 1; }
[ "$mal" = "Failed" ] || { echo "termina-error deberia estar en Failed (ahora: '$mal')"; exit 1; }
[ "${reinicios:-0}" -ge 1 ] || { echo "reinicia-siempre todavia no se ha reiniciado: espera unos segundos"; exit 1; }
