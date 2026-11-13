#!/bin/bash
# El generador de carga esta parado y el HPA ha devuelto php-apache a 1 replica.
ns=lab-10
gen=$(kubectl get deploy generador-carga -n $ns -o jsonpath='{.spec.replicas}' 2>/dev/null)
[ "$gen" = "0" ] || { echo "Falta parar la carga: escala generador-carga a 0 replicas (ahora: '$gen')"; exit 1; }
rep=$(kubectl get deploy php-apache -n $ns -o jsonpath='{.spec.replicas}' 2>/dev/null)
[ "$rep" = "1" ] || { echo "php-apache aun tiene '$rep' replicas: espera a que el HPA lo baje a 1 (unos 2-3 minutos)"; exit 1; }
