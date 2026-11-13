# Primera parte terminada

Has visto que:

- el plano de control lo forman etcd, kube-apiserver, kube-controller-manager y kube-scheduler, y en kubeadm arrancan como **static pods**,
- el kubelet ejecuta los manifiestos de su directorio de static pods sin pasar por el scheduler, y solo borrando el archivo desaparece el Pod,
- el API server es el único que habla con etcd, escucha en el 6443 y autoriza con RBAC,
- el kubelet y el runtime de contenedores son servicios de systemd, no Pods,
- `kube-proxy` y el plugin CNI son DaemonSets y CoreDNS es un Deployment,
- la salud del API server se consulta en `/livez` y `/readyz`.

El siguiente escenario sigue el recorrido de una petición: **Módulo 02 (2 de 3) · Controladores, API y kubeconfig**.

El clúster de esta sesión se borra al cerrar, así que no hace falta limpiar nada.
