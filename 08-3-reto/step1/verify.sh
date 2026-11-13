#!/bin/bash
# Reto del modulo 08: StorageClass con Retain, PVC de esa clase enlazado y un Pod que escribe en el.
ns=lab-08
falta() { echo "FALTA: $1"; exit 1; }

[ "$(kubectl get sc lab-08-retener -o jsonpath='{.provisioner}/{.reclaimPolicy}/{.volumeBindingMode}' 2>/dev/null)" = "rancher.io/local-path/Retain/WaitForFirstConsumer" ] \
  || falta "StorageClass 'lab-08-retener' con aprovisionador rancher.io/local-path, Retain y WaitForFirstConsumer"

kubectl get pvc reto-datos -n $ns >/dev/null 2>&1 || falta "no existe el PVC 'reto-datos' en $ns"
[ "$(kubectl get pvc reto-datos -n $ns -o jsonpath='{.spec.storageClassName}/{.spec.resources.requests.storage}')" = "lab-08-retener/64Mi" ] \
  || falta "el PVC 'reto-datos' debe pedir 64Mi de la clase lab-08-retener"
kubectl get pvc reto-datos -n $ns -o jsonpath='{.spec.accessModes[*]}' | grep -qw ReadWriteOnce \
  || falta "el PVC 'reto-datos' debe pedir el access mode ReadWriteOnce"
[ "$(kubectl get pvc reto-datos -n $ns -o jsonpath='{.status.phase}')" = "Bound" ] \
  || falta "el PVC 'reto-datos' debe estar Bound (con WaitForFirstConsumer, necesita un Pod que lo use)"

pv=$(kubectl get pvc reto-datos -n $ns -o jsonpath='{.spec.volumeName}')
[ -n "$pv" ] && [ "$(kubectl get pv "$pv" -o jsonpath='{.spec.persistentVolumeReclaimPolicy}' 2>/dev/null)" = "Retain" ] \
  || falta "el PV aprovisionado para 'reto-datos' debe tener reclaimPolicy Retain"

[ "$(kubectl get pod reto-app -n $ns -o jsonpath='{.status.phase}' 2>/dev/null)" = "Running" ] \
  || falta "el Pod 'reto-app' debe existir en $ns y estar Running"
kubectl get pod reto-app -n $ns -o jsonpath='{range .spec.volumes[*]}{.persistentVolumeClaim.claimName}{"\n"}{end}' | grep -qx reto-datos \
  || falta "el Pod 'reto-app' debe montar el PVC 'reto-datos'"

kubectl exec reto-app -n $ns -- cat /datos/hola.txt 2>/dev/null | grep -q kcna \
  || falta "dentro de 'reto-app', /datos/hola.txt debe contener 'kcna'"

echo "Reto superado"
