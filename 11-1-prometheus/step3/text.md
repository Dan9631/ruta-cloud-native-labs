Instala la release `prometheus` en `lab-11` con la versión fijada y tus valores. `--wait` hace que Helm espere a que todo esté listo; la primera vez descarga las imágenes y puede tardar 2 o 3 minutos:

`helm install prometheus prometheus-community/prometheus --version 29.37.2 -n lab-11 -f /root/lab/prometheus-values.yaml --wait --timeout 5m`{{exec}}

```text
NAME: prometheus
NAMESPACE: lab-11
STATUS: deployed
REVISION: 1
...
The Prometheus server can be accessed via port 80 on the following DNS name from within your cluster:
prometheus-server.lab-11.svc.cluster.local
...
######   WARNING: Persistence is disabled!!! You will lose your data when   #####
######            the Server pod is terminated.                             #####
```

Mira qué ha creado y dónde:

`kubectl get pods -n lab-11 -o wide`{{exec}}

```text
NAME                                             READY   STATUS    ...   IP            NODE
prometheus-kube-state-metrics-xxxxxxxxxx-xxxxx   1/1     Running   ...   10.x.x.x      ...
prometheus-prometheus-node-exporter-xxxxx        1/1     Running   ...   (IP nodo)     controlplane
prometheus-prometheus-node-exporter-xxxxx        1/1     Running   ...   (IP nodo)     node01
prometheus-server-xxxxxxxxxx-xxxxx               2/2     Running   ...   10.x.x.x      ...
```

Tus nombres e IP serán distintos. Compara las IP de node-exporter con las de los nodos:

`kubectl get nodes -o wide`{{exec}}

`kubectl get daemonset,deployment -n lab-11`{{exec}}

`helm list -n lab-11`{{exec}}

¿Por qué el servidor y kube-state-metrics caen en un nodo concreto? Depende de si `controlplane` acepta Pods normales:

`kubectl describe node controlplane | grep Taints`{{exec}}

**Qué observar**

- node-exporter es un **DaemonSet**: un Pod por nodo, incluido `controlplane` (los valores le dan una tolerancia para ello). En este clúster son 2; en el lab local del curso, con 3 nodos, eran 3.
- La IP de node-exporter es la **del nodo** (`hostNetwork`), porque mide el nodo, no el Pod.
- El servidor tiene 2 contenedores (`2/2`): Prometheus + el config reloader.
- Si `controlplane` tiene el taint `node-role.kubernetes.io/control-plane:NoSchedule`, el servidor y kube-state-metrics solo pueden ir a `node01`.

Pulsa **CHECK** cuando todos los Pods estén `Running`.
