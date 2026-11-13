Borra uno de los Pods del Deployment y vuelve a listar:

`kubectl delete $(kubectl get pods -n lab-02 -l app=hola -o name | head -1) -n lab-02`{{exec}}

`kubectl get pods -n lab-02 -l app=hola`{{exec}}

```text
NAME                    READY   STATUS    RESTARTS   AGE
hola-6ddd88c97d-6w5hf   1/1     Running   0          77s
hola-6ddd88c97d-pbgzp   1/1     Running   0          8s
```

Compara el estado deseado con el real, y la generación del `spec` con la que ya procesó el controlador:

`kubectl get deploy hola -n lab-02 -o jsonpath='{.spec.replicas} {.status.readyReplicas} {.metadata.generation} {.status.observedGeneration}'; echo`{{exec}}

```text
2 2 1 1
```

**Qué observar**

- Un Pod nuevo, con menos edad, reemplaza al borrado: el controlador de ReplicaSet vio 1 réplica donde el `spec` pedía 2 y corrigió la diferencia. Es el **bucle de reconciliación**: observar, comparar, actuar.
- `spec.replicas` (deseado, lo escribes tú) y `status.readyReplicas` (real, lo escriben los controladores) vuelven a coincidir.
- `metadata.generation` = `status.observedGeneration` indica que el controlador ya procesó el último `spec`. Borrar un Pod no cambia el `spec` del Deployment, así que la generación sigue en 1.

Pulsa **CHECK** cuando vuelva a haber 2 Pods listos.
