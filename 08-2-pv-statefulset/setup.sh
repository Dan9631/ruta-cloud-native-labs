#!/bin/bash
# Se ejecuta en segundo plano al abrir el escenario. Deja el cluster como lo da por hecho el laboratorio del modulo 08:
#   1) controlplane con el taint de control-plane, para que todos los Pods del lab vayan a node01;
#   2) local-path-provisioner (aprovisionador rancher.io/local-path) funcionando;
#   3) una StorageClass "standard" (rancher.io/local-path, Delete, WaitForFirstConsumer) como UNICA clase por defecto,
#      que es el nombre que usan los manifiestos del curso;
#   4) el namespace lab-08.
# Es idempotente: si algo ya esta, no lo toca.
LOCAL_PATH_VERSION=v0.0.37

until kubectl get nodes >/dev/null 2>&1; do sleep 2; done

# 1) Taint del plano de control (solo si falta)
for cp in $(kubectl get nodes -l node-role.kubernetes.io/control-plane -o name); do
  kubectl get "$cp" -o jsonpath='{.spec.taints[*].key}' | grep -q 'node-role.kubernetes.io/control-plane' \
    || kubectl taint "$cp" node-role.kubernetes.io/control-plane:NoSchedule
done

# 2) local-path-provisioner: se instala solo si no hay ya un Deployment que lo ejecute
if ! kubectl get deploy -A -o jsonpath='{range .items[*]}{.spec.template.spec.containers[*].image}{"\n"}{end}' | grep -q 'local-path-provisioner'; then
  for intento in $(seq 30); do
    kubectl apply -f "https://raw.githubusercontent.com/rancher/local-path-provisioner/${LOCAL_PATH_VERSION}/deploy/local-path-storage.yaml" && break
    sleep 5
  done
  kubectl -n local-path-storage rollout status deploy/local-path-provisioner --timeout=300s
fi

# 3) StorageClass "standard". Los campos provisioner, reclaimPolicy y volumeBindingMode no se pueden cambiar:
#    si existe con otros valores, se borra y se crea de nuevo.
actual=$(kubectl get sc standard -o jsonpath='{.provisioner}/{.reclaimPolicy}/{.volumeBindingMode}' 2>/dev/null)
if [ -n "$actual" ] && [ "$actual" != "rancher.io/local-path/Delete/WaitForFirstConsumer" ]; then
  kubectl delete sc standard
fi
for sc in $(kubectl get sc -o name); do
  [ "$sc" = "storageclass.storage.k8s.io/standard" ] \
    || kubectl annotate "$sc" storageclass.kubernetes.io/is-default-class=false --overwrite
done
kubectl apply -f - <<'EOF'
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: standard
  annotations:
    storageclass.kubernetes.io/is-default-class: "true"
provisioner: rancher.io/local-path
reclaimPolicy: Delete
volumeBindingMode: WaitForFirstConsumer
EOF

# 4) Namespace y carpeta de manifiestos
kubectl create namespace lab-08 --dry-run=client -o yaml | kubectl apply -f -
mkdir -p /root/lab
touch /tmp/listo
