#!/bin/bash
# La copia /root/kubeconfig-copia.yaml tiene el contexto 'practica' activo (cluster y usuario
# del contexto actual, namespace lab-02) y el kubeconfig de trabajo sigue con su contexto.
copia=/root/kubeconfig-copia.yaml
[ -s "$copia" ] || { echo "Falta la copia del kubeconfig en $copia"; exit 1; }

actual=$(kubectl config current-context 2>/dev/null)
[ "$actual" != "practica" ] || { echo "Has cambiado el contexto activo de tu kubeconfig de trabajo: el contexto 'practica' solo debe estar activo en la copia"; exit 1; }
cluster=$(kubectl config view --minify -o jsonpath='{.contexts[0].context.cluster}')
usuario=$(kubectl config view --minify -o jsonpath='{.contexts[0].context.user}')

[ "$(kubectl config current-context --kubeconfig "$copia" 2>/dev/null)" = "practica" ] \
  || { echo "El contexto activo de la copia debe ser 'practica' (usa use-context con --kubeconfig $copia)"; exit 1; }
estado=$(kubectl config view --kubeconfig "$copia" -o jsonpath='{.contexts[?(@.name=="practica")].context.cluster}/{.contexts[?(@.name=="practica")].context.user}/{.contexts[?(@.name=="practica")].context.namespace}' 2>/dev/null)
[ "$estado" = "$cluster/$usuario/lab-02" ] \
  || { echo "El contexto 'practica' de la copia debe usar el cluster '$cluster', el usuario '$usuario' y el namespace lab-02 (ahora: '$estado')"; exit 1; }
