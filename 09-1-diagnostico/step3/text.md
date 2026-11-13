**Paso 4 de la metodología: `logs`.** Con `-l` lees varios Pods a la vez sin buscar sus nombres; `--prefix` dice de quién es cada línea:

`kubectl logs -n lab-09 -l app=frontend --tail=2 --prefix`{{exec}}

```text
[pod/frontend-7bb584f994-47mg7/nginx] 2026/10/23 15:43:46 [notice] 1#1: start worker process 36
[pod/frontend-7bb584f994-47mg7/nginx] 2026/10/23 15:43:46 [notice] 1#1: start worker process 37
[pod/frontend-7bb584f994-hzrdq/nginx] 2026/10/23 15:43:56 [notice] 1#1: start worker process 36
[pod/frontend-7bb584f994-hzrdq/nginx] 2026/10/23 15:43:56 [notice] 1#1: start worker process 37
```

Contra un Deployment, `logs` elige uno de sus Pods. Con `-f` sigue en vivo; sal con `Ctrl+C`:

`kubectl logs -n lab-09 deploy/frontend -f`{{exec}}

Para un contenedor que se reinicia, lo que importa es lo que dijo **antes de morir**: eso es `--previous`. Lo usarás en el reto.

**Paso 5: `exec`**, mirar desde dentro de un contenedor vivo:

`kubectl exec -n lab-09 deploy/frontend -- nginx -v`{{exec}}

```text
nginx version: nginx/1.27.5
```

Ahora un Pod cliente para probar la red desde dentro del clúster. Lo dejamos vivo con un `sleep` para usarlo varias veces:

`kubectl run cliente -n lab-09 --image=busybox:1.37 -- sleep 3600`{{exec}}

`kubectl wait pod/cliente -n lab-09 --for=condition=Ready --timeout=60s`{{exec}}

Prueba el Service `frontend`, que ya arreglaste, y después el Service `shop`:

`kubectl exec -n lab-09 cliente -- wget -qO- -T 3 http://frontend | head -4`{{exec}}

`kubectl exec -n lab-09 cliente -- wget -qO- -T 3 http://shop`{{exec}}

```text
wget: can't connect to remote host (10.96.126.219): Connection refused
command terminated with exit code 1
```

Mira por qué:

`kubectl get svc,endpointslices -n lab-09`{{exec}}

**Qué observar**

- `frontend` responde con la página de nginx: el nombre del Service se resuelve por DNS dentro del namespace.
- El Service `shop` existe y tiene IP, pero rechaza la conexión. Su EndpointSlice no tiene direcciones: es el síntoma típico de un **Service sin endpoints**. Lo resolverás en el reto. Según la implementación de red del clúster, en vez de `Connection refused` podrías ver un *timeout*.
- `exec` solo funciona con un contenedor **vivo**. Con un Pod en `CrashLoopBackOff` necesitarás otra herramienta (`kubectl debug`, en la segunda parte).

Pulsa **CHECK** cuando el Pod `cliente` esté `Running`.
