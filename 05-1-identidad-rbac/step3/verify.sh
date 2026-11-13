#!/bin/bash
# La ServiceAccount lector existe y su Role le deja leer Pods en lab-05, pero no Secrets.
sa=system:serviceaccount:lab-05:lector
kubectl get serviceaccount lector -n lab-05 >/dev/null 2>&1 || { echo "Falta la ServiceAccount lector en lab-05: aplica 01-sa-lector.yaml"; exit 1; }
[ "$(kubectl auth can-i list pods -n lab-05 --as=$sa 2>/dev/null)" = "yes" ] || { echo "lector todavia no puede listar Pods en lab-05: revisa el Role y el RoleBinding lector-pods"; exit 1; }
[ "$(kubectl auth can-i get secrets -n lab-05 --as=$sa 2>/dev/null)" = "no" ] || { echo "lector no deberia poder leer Secrets en lab-05"; exit 1; }
