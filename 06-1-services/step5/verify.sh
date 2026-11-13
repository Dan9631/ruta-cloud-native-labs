#!/bin/bash
# Service headless whoami-headless (clusterIP None) y Service ExternalName buscador -> www.example.com.
ns=lab-06
ip=$(kubectl get svc whoami-headless -n $ns -o jsonpath='{.spec.clusterIP}' 2>/dev/null)
[ "$ip" = "None" ] || { echo "Falta el Service headless whoami-headless (clusterIP: None) en $ns"; exit 1; }
ext=$(kubectl get svc buscador -n $ns -o jsonpath='{.spec.type}/{.spec.externalName}' 2>/dev/null)
[ "$ext" = "ExternalName/www.example.com" ] || { echo "Falta el Service buscador de tipo ExternalName hacia www.example.com en $ns (ahora: '$ext')"; exit 1; }
