#!/bin/bash
# El Job calculo completo sus 3 ejecuciones y el CronJob reporte ya disparo al menos una vez.
hechos=$(kubectl get job calculo -n lab-03 -o jsonpath='{.status.succeeded}' 2>/dev/null)
[ "$hechos" = "3" ] || { echo "El Job calculo deberia tener 3 ejecuciones completadas (ahora: '$hechos')"; exit 1; }
ultimo=$(kubectl get cronjob reporte -n lab-03 -o jsonpath='{.status.lastScheduleTime}' 2>/dev/null)
[ -n "$ultimo" ] || { echo "El CronJob reporte todavia no ha creado ningun Job: espera un minuto"; exit 1; }
