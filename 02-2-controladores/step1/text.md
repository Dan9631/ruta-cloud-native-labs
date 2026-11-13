Crea un Deployment de 2 réplicas y espera a que termine de desplegarse:

`kubectl create deployment hola -n lab-02 --image=nginx:1.27-alpine --replicas=2`{{exec}}

`kubectl rollout status deploy/hola -n lab-02`{{exec}}

Ahora lee los eventos en orden. Cada uno lo emite un componente distinto:

`kubectl get events -n lab-02 --sort-by=.lastTimestamp`{{exec}}

```text
LAST SEEN   TYPE     REASON              OBJECT                       MESSAGE
12s         Normal   ScalingReplicaSet   deployment/hola              Scaled up replica set hola-6ddd88c97d from 0 to 2
12s         Normal   SuccessfulCreate    replicaset/hola-6ddd88c97d   Created pod: hola-6ddd88c97d-5hk6d
12s         Normal   Scheduled           pod/hola-6ddd88c97d-5hk6d    Successfully assigned lab-02/hola-6ddd88c97d-5hk6d to node01
11s         Normal   Pulling             pod/hola-6ddd88c97d-5hk6d    Pulling image "nginx:1.27-alpine"
6s          Normal   Pulled              pod/hola-6ddd88c97d-5hk6d    Successfully pulled image "nginx:1.27-alpine" ...
6s          Normal   Created             pod/hola-6ddd88c97d-5hk6d    Container created
6s          Normal   Started             pod/hola-6ddd88c97d-5hk6d    Container started
...
```

**Qué observar**

- Los eventos ocurren casi a la vez y el orden exacto puede variar, pero identifica a cada actor:
  - `ScalingReplicaSet`: el controlador de **Deployment** crea el ReplicaSet.
  - `SuccessfulCreate`: el controlador de **ReplicaSet** crea los Pods, todavía sin nodo.
  - `Scheduled`: el **kube-scheduler** elige el nodo y lo escribe en `spec.nodeName`.
  - `Pulling`/`Pulled`/`Created`/`Started`: el **kubelet** del nodo elegido pide al runtime la imagen y el contenedor.
- Nadie da órdenes a nadie: cada componente **observa** (*watch*) el API server y reacciona.
- Aquí la imagen se descarga de Docker Hub, así que verás `Pulling`. En el lab local estaba precargada y salía `already present on machine`.

Pulsa **CHECK** cuando el Deployment tenga 2 réplicas listas.
