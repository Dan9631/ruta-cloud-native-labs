#!/bin/bash
# El Pod nginx tiene el label env=dev y la annotation responsable=equipo-web.
estado=$(kubectl get pod nginx -n lab-03 -o jsonpath='{.metadata.labels.env}/{.metadata.annotations.responsable}' 2>/dev/null)
[ "$estado" = "dev/equipo-web" ] || { echo "Falta el label env=dev o la annotation responsable=equipo-web en el Pod nginx (ahora: '$estado')"; exit 1; }
