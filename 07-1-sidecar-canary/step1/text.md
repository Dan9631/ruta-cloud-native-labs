Mira el manifiesto: nginx escribe sus logs en un volumen `emptyDir` montado en `/var/log/nginx`; el sidecar `log-tail` (un init container con `restartPolicy: Always`) monta el mismo volumen en solo lectura y hace `tail -F` del log de accesos.

`cat /root/lab/01-native-sidecar.yaml`{{exec}}

Créalo y espera a que esté listo:

`kubectl apply -f /root/lab/01-native-sidecar.yaml`{{exec}}

`kubectl wait --for=condition=Ready pod/web-con-sidecar -n lab-07 --timeout=90s`{{exec}}

`kubectl get pod web-con-sidecar -n lab-07`{{exec}}

`kubectl get pod web-con-sidecar -n lab-07 -o jsonpath='{.spec.initContainers[0].name} restartPolicy={.spec.initContainers[0].restartPolicy}'; echo`{{exec}}

```text
NAME              READY   STATUS    RESTARTS   AGE
web-con-sidecar   2/2     Running   0          11s
log-tail restartPolicy=Always
```

Ahora mira en qué orden arrancó cada contenedor:

`kubectl get events -n lab-07 --field-selector involvedObject.name=web-con-sidecar --sort-by=.metadata.creationTimestamp -o custom-columns='RAZON:.reason,MENSAJE:.message'`{{exec}}

```text
RAZON       MENSAJE
Scheduled   Successfully assigned lab-07/web-con-sidecar to node01
Pulling     Pulling image "busybox:1.37"
Pulled      Successfully pulled image "busybox:1.37" in ...
Created     ...
Started     ...
Pulling     Pulling image "nginx:1.27-alpine"
Pulled      Successfully pulled image "nginx:1.27-alpine" in ...
Created     ...
Started     ...
```

Aquí las imágenes se descargan de internet, así que verás eventos `Pulling` que no aparecían en el clúster local (allí estaban precargadas). El nodo puede ser `node01` o `controlplane`.

**Qué observar**

- El Pod muestra `2/2` aunque solo hay un contenedor en `containers`: el sidecar nativo cuenta como contenedor en ejecución. Un init container normal habría terminado y el Pod mostraría `1/1`.
- Primero se arranca la imagen `busybox` (el sidecar) y solo después `nginx`. Esa garantía de orden es la que necesita, por ejemplo, un proxy de mesh.

Pulsa **CHECK**.
