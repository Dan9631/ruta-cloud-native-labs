Mira lo que vas a desplegar. Son seis aplicaciones pequeñas; todas tienen algún fallo:

`ls /root/lab/rotos`{{exec}}

`kubectl apply` acepta una carpeta entera:

`kubectl apply -f /root/lab/rotos/`{{exec}}

```text
deployment.apps/frontend created
service/frontend created
deployment.apps/api created
deployment.apps/cache created
deployment.apps/worker created
configmap/report-config created
deployment.apps/reporter created
deployment.apps/shop created
service/shop created
```

Que todo se haya «creado» no significa que funcione: la API solo validó la sintaxis.

**Paso 1 de la metodología: `get`.** Espera un minuto (las imágenes se descargan de internet) y mira el panorama:

`kubectl get pods -n lab-09 -o wide`{{exec}}

```text
NAME                        READY   STATUS                       RESTARTS      AGE   IP           NODE
api-5d6c56d657-8tzbk        0/1     Error                        3 (44s ago)   71s   10.244.1.9   node01
cache-854b994f8f-fw58h      0/1     Pending                      0             70s   <none>       <none>
frontend-56dbbc8bcc-hmzm9   0/1     ImagePullBackOff             0             72s   10.244.1.5   node01
frontend-56dbbc8bcc-hrx7n   0/1     ErrImagePull                 0             72s   10.244.1.8   node01
reporter-54b6b5cfc8-scldj   0/1     CreateContainerConfigError   0             68s   10.244.1.11  node01
shop-5dc894c86f-dfrxn       1/1     Running                      3 (11s ago)   67s   10.244.1.12  node01
shop-5dc894c86f-vzqkl       0/1     CrashLoopBackOff             3 (6s ago)    67s   10.244.1.6   node01
worker-69c876967-wbrlh      0/1     OOMKilled                    2 (47s ago)   69s   10.244.1.10  node01
```

Repite el comando un par de veces: los estados cambian según el momento en que mires. Los nombres de los Pods y las IP serán otros en tu clúster.

**Qué observar**

- Casi todo el catálogo de estados en una sola pantalla: `Pending`, `ErrImagePull`/`ImagePullBackOff`, `CreateContainerConfigError`, `Error`/`CrashLoopBackOff`, `OOMKilled`.
- `cache` no tiene IP ni nodo: **nunca fue programado**. El problema está antes de que exista un contenedor.
- `shop` a ratos aparece `1/1 Running`, pero sus reinicios suben.
- Los estados oscilan (`Error` ↔ `CrashLoopBackOff`, `ErrImagePull` ↔ `ImagePullBackOff`). Ninguno de ellos es una fase del Pod: las fases son solo `Pending`, `Running`, `Succeeded`, `Failed` y `Unknown`.
- Todo cae en `node01`: en este clúster el `controlplane` tiene un taint que impide programar aplicaciones en él. En el clúster del curso, de tres nodos, se reparten entre dos workers.

Pulsa **CHECK**.
