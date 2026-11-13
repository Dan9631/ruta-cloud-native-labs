#!/bin/bash
# Reto del modulo 02: ConfigMap 'arquitectura' con datos reales del cluster y contexto 'lab02' en el kubeconfig.
ns=lab-02
falta() { echo "FALTA: $1"; exit 1; }
clave() { kubectl get configmap arquitectura -n $ns -o jsonpath="{.data.$1}" 2>/dev/null; }

kubectl get configmap arquitectura -n $ns >/dev/null 2>&1 || falta "no existe el ConfigMap 'arquitectura' en $ns"

real=$(kubectl get pods -n kube-system -l component=etcd -o jsonpath='{.items[0].spec.nodeName}')
[ -n "$real" ] && [ "$(clave etcd-node)" = "$real" ] \
  || falta "la clave etcd-node debe ser el nodo donde corre etcd"

real=$(kubectl get pods -n kube-system -l component=kube-apiserver -o jsonpath='{.items[0].spec.containers[0].image}')
[ -n "$real" ] && [ "$(clave apiserver-image)" = "$real" ] \
  || falta "la clave apiserver-image debe ser la imagen completa (con tag) del kube-apiserver"

real=$(ls /etc/kubernetes/manifests | wc -l)
[ "$real" -gt 0 ] && [ "$(clave static-pods)" = "$real" ] \
  || falta "la clave static-pods debe ser el numero de manifiestos en /etc/kubernetes/manifests de controlplane"

real=$(kubectl get deploy coredns -n kube-system -o jsonpath='{.spec.replicas}')
[ -n "$real" ] && [ "$(clave coredns-replicas)" = "$real" ] \
  || falta "la clave coredns-replicas debe ser el numero de replicas deseadas de CoreDNS"

[ "$(clave deployment-api)" = "apps/v1" ] \
  || falta "la clave deployment-api debe ser el apiVersion de un Deployment"

[ "$(kubectl config current-context)" != "lab02" ] \
  || falta "no cambies el contexto activo: vuelve al contexto anterior con 'kubectl config use-context'"
cluster=$(kubectl config view --minify -o jsonpath='{.contexts[0].context.cluster}')
usuario=$(kubectl config view --minify -o jsonpath='{.contexts[0].context.user}')
estado=$(kubectl config view -o jsonpath='{.contexts[?(@.name=="lab02")].context.cluster}/{.contexts[?(@.name=="lab02")].context.user}/{.contexts[?(@.name=="lab02")].context.namespace}')
[ "$estado" = "$cluster/$usuario/lab-02" ] \
  || falta "el kubeconfig debe tener un contexto 'lab02' con el cluster '$cluster', el usuario '$usuario' y el namespace lab-02"

echo "Reto superado"
