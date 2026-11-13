Crea un Pod con una versión de tu imagen que no has construido ni importado:

`kubectl run sin-cargar -n lab-01 --image=localhost/kcna-web:9.9`{{exec}}

`kubectl get pod sin-cargar -n lab-01`{{exec}}

Repite el último comando hasta ver `ErrImagePull` o `ImagePullBackOff`. Luego lee el motivo:

`kubectl describe pod sin-cargar -n lab-01 | grep -E 'Failed|BackOff'`{{exec}}

```text
NAME         READY   STATUS             RESTARTS   AGE
sin-cargar   0/1     ImagePullBackOff   0          23s
  Warning  Failed   ...  Failed to pull image "localhost/kcna-web:9.9": ... dial tcp 127.0.0.1:443: connect: connection refused
  Normal   BackOff  ...  Back-off pulling image "localhost/kcna-web:9.9"
```

El texto exacto del error puede variar según la versión de containerd; lo importante es que intenta descargar la imagen y no puede.

**Qué observar**

- Como la imagen no está en el nodo, el kubelet intenta descargarla de un registry llamado `localhost` (la primera parte del nombre), que no existe.
- Primero sale `ErrImagePull` y después `ImagePullBackOff`: reintentos con una espera cada vez mayor.
- Este diagnóstico se pregunta mucho: nombre o tag mal escrito, registry inaccesible o falta de credenciales (`imagePullSecrets`).

Pulsa **CHECK** cuando el Pod esté en `ErrImagePull` o `ImagePullBackOff`.
