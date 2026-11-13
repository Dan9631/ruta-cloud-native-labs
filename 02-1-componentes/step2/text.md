El kubelet vigila un directorio local y arranca cualquier manifiesto de Pod que encuentre ahí, sin pasar por el scheduler ni por el API server. Así arranca kubeadm el propio plano de control.

Estás en `controlplane`. Mira el directorio y dónde lo configura el kubelet:

`ls /etc/kubernetes/manifests`{{exec}}

`grep staticPodPath /var/lib/kubelet/config.yaml`{{exec}}

```text
etcd.yaml
kube-apiserver.yaml
kube-controller-manager.yaml
kube-scheduler.yaml
staticPodPath: /etc/kubernetes/manifests
```

Lo que ves con `kubectl` es un **mirror pod**, una copia de solo lectura que el kubelet publica en la API. Mira quién es su dueño y sus annotations:

`kubectl get pods -n kube-system -l component=etcd -o jsonpath='{.items[0].metadata.ownerReferences[0].kind}/{.items[0].metadata.ownerReferences[0].name}'; echo`{{exec}}

`kubectl get pods -n kube-system -l component=kube-apiserver -o jsonpath='{.items[0].metadata.annotations}'; echo`{{exec}}

```text
Node/controlplane
{"kubeadm.kubernetes.io/kube-apiserver.advertise-address.endpoint":"...:6443","kubernetes.io/config.hash":"...","kubernetes.io/config.mirror":"...","kubernetes.io/config.seen":"...","kubernetes.io/config.source":"file"}
```

**Tu propio static pod.** Comprueba que el kubelet de `node01` vigila el mismo directorio. Allí no hay ningún manifiesto (el `mkdir -p` lo crea por si ni siquiera existe):

`ssh node01 grep staticPodPath /var/lib/kubelet/config.yaml`{{exec}}

`ssh node01 'mkdir -p /etc/kubernetes/manifests && ls -la /etc/kubernetes/manifests'`{{exec}}

Lee el manifiesto y cópialo a ese directorio de `node01`:

`cat /root/lab/estatico.yaml`{{exec}}

`scp /root/lab/estatico.yaml node01:/etc/kubernetes/manifests/`{{exec}}

En unos segundos aparece su mirror pod, con el nombre del nodo como sufijo:

`kubectl get pods -n lab-02 -o wide`{{exec}}

```text
NAME              READY   STATUS    RESTARTS   AGE   IP     NODE     ...
estatico-node01   1/1     Running   0          12s   ...    node01   ...
```

Intenta borrarlo con `kubectl` y vuelve a listar:

`kubectl delete pod estatico-node01 -n lab-02`{{exec}}

`kubectl get pods -n lab-02`{{exec}}

**Qué observar**

- kubeadm pone en el directorio de static pods los cuatro componentes del plano de control: `etcd`, `kube-apiserver`, `kube-controller-manager` y `kube-scheduler`.
- El dueño del mirror pod es el **Node**, no un ReplicaSet. Las annotations `kubernetes.io/config.mirror` y `kubernetes.io/config.source: file` delatan que viene de un archivo.
- Tu Pod `estatico` no lo creó el scheduler: el kubelet de `node01` lo arrancó al ver el archivo. Por eso cae en `node01` aunque nadie lo haya pedido.
- Al borrar el mirror pod, el kubelet lo vuelve a publicar: el Pod de verdad lo define el archivo. En el lab local entrabas en el nodo con `podman exec`; aquí, como en un clúster real, entras por SSH.

Pulsa **CHECK** cuando `estatico-node01` esté `Running`.
