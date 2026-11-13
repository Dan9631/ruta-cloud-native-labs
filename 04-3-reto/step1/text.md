Deja el namespace `lab-04` y los nodos así:

1. El nodo `node01` tiene el taint `lab-04-reto=gpu:NoSchedule` (imagina que es el nodo con GPU).
2. Un Pod llamado `entrenamiento` (imagen `nginx:1.27-alpine`) que **tolere** ese taint y que vaya **obligatoriamente** a `node01` usando su label `zone=zona-b`. Prohibido usar `nodeName`.
3. Un Deployment `api` (imagen `nginx:1.27-alpine`, Pods con label `app=api`) con 2 réplicas que solo puedan correr en nodos `disktype=ssd`, y cuyos Pods tengan QoS class **Guaranteed**. Usa valores pequeños, por ejemplo 50m y 32Mi.
4. Un DaemonSet `monitor` (imagen `busybox:1.37`, comando `sleep 86400`) con un Pod listo en **los 2 nodos**.
5. Una ResourceQuota `cuota` que limite `lab-04` a 10 Pods.

**Pistas**

- Piensa en todos los taints que habrá en el clúster cuando crees el DaemonSet.
- Mira los taints actuales: `kubectl get nodes -o custom-columns='NODO:.metadata.name,TAINTS:.spec.taints[*].key'`{{exec}}
- `kubectl explain pod.spec.tolerations`{{exec}}
- `kubectl explain pod.spec.affinity.nodeAffinity`{{exec}}
- Para empezar un manifiesto: `kubectl run entrenamiento --image=nginx:1.27-alpine -n lab-04 --dry-run=client -o yaml > reto04.yaml`{{copy}} y complétalo con `nano` o `vim`.
- Un DaemonSet no se puede generar con `kubectl create`: parte de un Deployment generado con `--dry-run=client -o yaml`, cambia el `kind` y quita `replicas` y `strategy`.

Cuando creas que está, pulsa **CHECK**.

**Si te atascas**

Hay una solución completa en `/root/solucion`. Inténtalo antes de mirarla:

`cat /root/solucion/pasos.txt`{{copy}}
