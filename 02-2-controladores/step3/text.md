Con `-v=6` kubectl escribe en su salida de errores cada petición HTTP que hace. Filtra las URLs:

`kubectl get pods -n lab-02 -v=6 2>&1 | grep 'url='`{{exec}}

```text
I1023 10:13:31.748296   22252 round_trippers.go:632] "Response" verb="GET" url="https://...:6443/api/v1/namespaces/lab-02/pods?limit=500" status="200 OK" milliseconds=8
```

Haz lo mismo con los Deployments:

`kubectl get deployments -n lab-02 -v=6 2>&1 | grep 'url='`{{exec}}

Y pide tú la ruta REST directamente, sin que kubectl la construya:

`kubectl get --raw /apis/apps/v1/namespaces/lab-02/deployments/hola | head -c 300; echo`{{exec}}

**Qué observar**

- `kubectl get pods` es un simple `GET /api/v1/namespaces/lab-02/pods`. Pod es del grupo **core**, que cuelga de `/api/v1`.
- Deployment es del grupo **apps**, así que va a `/apis/apps/v1/...`.
- `--raw` devuelve el JSON tal cual lo guarda y sirve el API server. kubectl solo da formato a esas respuestas.
- kubectl saca la URL del servidor y las credenciales del **kubeconfig**. Lo verás en el último paso.

Este paso no tiene comprobación. Pulsa **NEXT**.
