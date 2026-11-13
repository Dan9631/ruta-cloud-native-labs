Empezamos por `frontend`. **Paso 2 de la metodología: `describe`.** Tiene dos réplicas, así que lo pedimos por label:

`kubectl describe pod -n lab-09 -l app=frontend --show-events`{{exec}}

Cuando `describe` muestra varios objetos a la vez omite los eventos, salvo que los pidas con `--show-events`. Baja hasta la sección `Events` (resumida):

```text
Events:
  Type     Reason     From               Message
  Normal   Scheduled  default-scheduler  Successfully assigned lab-09/frontend-... to node01
  Normal   Pulling    kubelet            Pulling image "nginx:1.27-alpinee"
  Warning  Failed     kubelet            Failed to pull image "nginx:1.27-alpinee": ... failed to resolve reference
                                         "docker.io/library/nginx:1.27-alpinee": ... not found
  Warning  Failed     kubelet            Error: ErrImagePull
  Normal   BackOff    kubelet            Back-off pulling image "nginx:1.27-alpinee"
  Warning  Failed     kubelet            Error: ImagePullBackOff
```

**Paso 3: los eventos de todo el namespace**, ordenados en el tiempo:

`kubectl get events -n lab-09 --sort-by=.lastTimestamp | tail -15`{{exec}}

```text
LAST SEEN   TYPE      REASON      OBJECT                          MESSAGE
...
42s         Warning   Unhealthy   pod/shop-5dc894c86f-vzqkl       Liveness probe failed: Get "http://10.244.1.6:8080/": dial tcp ... connection refused
42s         Normal    Killing     pod/shop-5dc894c86f-vzqkl       Container web failed liveness probe, will be restarted
15s         Warning   BackOff     pod/worker-69c876967-wbrlh      Back-off restarting failed container worker in pod ...
4s          Warning   Failed      pod/reporter-54b6b5cfc8-scldj   Error: configmap "reporter-config" not found
2s          Warning   Failed      pod/frontend-56dbbc8bcc-hmzm9   Error: ImagePullBackOff
```

Para los eventos de un solo objeto existe el comando moderno `kubectl events --for pod/<nombre> -n lab-09`.

**El estado «en crudo».** En el YAML completo hay dos niveles de *reason*:

`kubectl get pod -n lab-09 -l app=frontend -o yaml | grep -E 'image:|reason:' | head -4`{{exec}}

`kubectl get pod -n lab-09 -l app=frontend -o jsonpath='{.items[0].status.containerStatuses[0].state.waiting.reason}'; echo`{{exec}}

```text
    - image: nginx:1.27-alpinee
      reason: ContainersNotReady
      reason: ContainersNotReady
    - image: nginx:1.27-alpinee
ImagePullBackOff
```

**Ahora arréglalo tú.** Ya tienes la causa. Corrige el Deployment `frontend` para que sus dos réplicas arranquen. Hay dos formas válidas: editar `/root/lab/rotos/01-frontend.yaml` y volver a aplicarlo (el archivo es la fuente de verdad), o corregir en caliente con `kubectl set image` o `kubectl edit`.

Cuando lo tengas, comprueba que el rollout terminó y que el Service ya tiene endpoints:

`kubectl rollout status deployment/frontend -n lab-09`{{exec}}

`kubectl get endpointslices -n lab-09 -l kubernetes.io/service-name=frontend`{{exec}}

```text
NAME             ADDRESSTYPE   PORTS   ENDPOINTS                 AGE
frontend-bdvtf   IPv4          80      10.244.1.20,10.244.1.21   7m4s
```

**Qué observar**

- **Lee el mensaje completo** del evento: `not found` apunta a un nombre o tag que no existe; `unauthorized` a credenciales; `timeout` a la red.
- La regla práctica: si el problema ocurre **antes** de que arranque el contenedor (scheduling, imagen, configuración), la respuesta está en `describe` y en los eventos. Si ocurre **después**, está en los logs.
- La columna STATUS de `get pods` es `status.containerStatuses[].state.waiting.reason`; `ContainersNotReady` es la reason de una *condition* del Pod.
- `set image` cambia la plantilla del Deployment, así que se crea un ReplicaSet nuevo (cambia el hash del nombre). Si arreglas en caliente, corrige también el YAML o la próxima vez que lo apliques volverás a romperlo.
- Los eventos se conservan solo alrededor de una hora. Ya te están dando pistas de los otros casos: guárdalas para el reto.

**Solución** (léela solo si te atascas; los comandos se copian, no se ejecutan solos)

La imagen tiene una errata en el tag: `1.27-alpinee` (sobra una «e»). El Pod **sí** se programó (`Scheduled`), así que el fallo es posterior: la descarga de la imagen.

Arreglo en caliente:

`kubectl set image deployment/frontend nginx=nginx:1.27-alpine -n lab-09`{{copy}}

O corrigiendo el archivo y aplicándolo:

`sed -i 's/1.27-alpinee/1.27-alpine/' /root/lab/rotos/01-frontend.yaml && kubectl apply -f /root/lab/rotos/01-frontend.yaml`{{copy}}

Pulsa **CHECK** cuando `frontend` tenga sus dos réplicas listas.
