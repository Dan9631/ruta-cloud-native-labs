#!/bin/bash
# El Secret db-cred existe en lab-05 con usuario=app y password=NoSoyCifrado123.
pw=$(kubectl get secret db-cred -n lab-05 -o jsonpath='{.data.password}' 2>/dev/null | base64 -d 2>/dev/null)
us=$(kubectl get secret db-cred -n lab-05 -o jsonpath='{.data.usuario}' 2>/dev/null | base64 -d 2>/dev/null)
[ "$us/$pw" = "app/NoSoyCifrado123" ] || { echo "Falta el Secret db-cred en lab-05 con usuario=app y password=NoSoyCifrado123"; exit 1; }
