Empieza por ver qué StorageClasses tiene el clúster:

`kubectl get sc`{{exec}}

```text
NAME                 PROVISIONER             RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
local-path           rancher.io/local-path   Delete          WaitForFirstConsumer   false                  2m
standard (default)   rancher.io/local-path   Delete          WaitForFirstConsumer   false                  2m
```

`local-path` es la clase que trae el instalador del aprovisionador (puede no aparecer o llamarse de otra forma si el clúster ya traía uno). La que usan los manifiestos es `standard`, la marcada `(default)`. El aprovisionador corre como un Pod más:

`kubectl get pods -A | grep local-path`{{exec}}

Ahora un volumen que no tiene nada de persistente. Lee el Pod: dos contenedores comparten un `emptyDir`; `escritor` añade una línea cada 5 segundos y `lector` la lee.

`cat /root/lab/01-emptydir.yaml`{{exec}}

`kubectl apply -f /root/lab/01-emptydir.yaml`{{exec}}

`kubectl wait --for=condition=Ready pod/compartido -n lab-08 --timeout=90s; sleep 12`{{exec}}

`kubectl logs compartido -n lab-08 -c lector`{{exec}}

```text
16:52:41 escrito por compartido
16:52:47 escrito por compartido
16:52:52 escrito por compartido
```

Borra el Pod, créalo de nuevo y vuelve a mirar:

`kubectl delete pod compartido -n lab-08`{{exec}}

`kubectl apply -f /root/lab/01-emptydir.yaml`{{exec}}

`kubectl wait --for=condition=Ready pod/compartido -n lab-08 --timeout=90s; sleep 4`{{exec}}

`kubectl logs compartido -n lab-08 -c lector`{{exec}}

```text
16:58:44 escrito por compartido
```

**Qué observar**

- La clase por defecto usa `Delete` (los datos se borran con el PVC), `WaitForFirstConsumer` y **no** permite expansión.
- `escritor` escribe en `/cache/log.txt` y `lector` lee el **mismo** archivo en `/compartida/log.txt`: lo que importa es el nombre del volumen, no la ruta de montaje.
- Tras recrear el Pod, las líneas antiguas han desaparecido. El emptyDir vive lo que vive el Pod.

Pulsa **CHECK** cuando el Pod `compartido` esté listo.
