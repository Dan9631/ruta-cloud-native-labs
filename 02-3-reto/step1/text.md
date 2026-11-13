Documenta la arquitectura **real** de este clúster y prepara un contexto de trabajo:

1. Crea en `lab-02` un ConfigMap llamado `arquitectura` con estas claves, rellenando los valores que **descubras con comandos** (no los adivines):
   - `etcd-node`: nombre del nodo donde corre etcd.
   - `apiserver-image`: imagen completa (registry/nombre:tag) del kube-apiserver.
   - `static-pods`: cuántos manifiestos hay en el directorio de static pods de `controlplane`.
   - `coredns-replicas`: réplicas deseadas del Deployment de CoreDNS.
   - `deployment-api`: el `apiVersion` que se usa para un Deployment.
2. Añade a tu kubeconfig un contexto llamado `lab02` que use el **mismo cluster y el mismo usuario que el contexto actual** y el namespace `lab-02`. **No cambies el contexto activo.**

**Pistas**

- Los static pods del plano de control llevan el label `component` (por ejemplo `component=etcd`). Con `-o jsonpath` sacas un campo concreto, como `spec.nodeName`.
- Estás en `controlplane`: el directorio de static pods lo dice `staticPodPath` en `/var/lib/kubelet/config.yaml`.
- `kubectl api-resources --api-group=apps`{{exec}}
- `kubectl config view --minify`{{exec}} te dice el cluster y el usuario del contexto actual.
- `kubectl config set-context --help`{{exec}}

Cuando creas que está, pulsa **CHECK**.

**Si te atascas**

Hay una solución completa en `/root/solucion`. Inténtalo antes de mirarla:

`cat /root/solucion/pasos.txt`{{copy}}
