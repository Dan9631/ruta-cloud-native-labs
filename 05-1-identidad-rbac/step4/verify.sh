#!/bin/bash
# lector puede listar nodos (no borrarlos) gracias al ClusterRole/ClusterRoleBinding lab-05-lector-nodos.
sa=system:serviceaccount:lab-05:lector
kubectl get clusterrolebinding lab-05-lector-nodos >/dev/null 2>&1 || { echo "Falta el ClusterRoleBinding lab-05-lector-nodos: aplica 02-clusterrole-nodos.yaml"; exit 1; }
[ "$(kubectl auth can-i list nodes --as=$sa 2>/dev/null)" = "yes" ] || { echo "lector todavia no puede listar nodos"; exit 1; }
[ "$(kubectl auth can-i delete nodes --as=$sa 2>/dev/null)" = "no" ] || { echo "lector no deberia poder borrar nodos"; exit 1; }
