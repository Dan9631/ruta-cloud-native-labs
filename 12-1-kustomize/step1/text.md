La **base** es lo común a todos los entornos. Mírala:

`cat /root/lab/kustomize/base/kustomization.yaml /root/lab/kustomize/base/deployment.yaml /root/lab/kustomize/base/service.yaml`{{exec}}

El overlay **dev** reutiliza la base y solo declara lo que cambia:

`cat /root/lab/kustomize/overlays/dev/kustomization.yaml`{{exec}}

Renderiza el overlay sin tocar el clúster. Con `tee` lo ves en pantalla y además queda guardado en `/root/dev.yaml`:

`kubectl kustomize /root/lab/kustomize/overlays/dev | tee /root/dev.yaml`{{exec}}

```text
apiVersion: v1
kind: Service
metadata:
  labels:
    app: web
    env: dev
  name: dev-web
  namespace: lab-12
...
kind: Deployment
...
  replicas: 1
  selector:
    matchLabels:
      app: web
      env: dev
```

**Qué observar**

- El overlay no repite nada de la base: solo añade el prefijo `dev-`, el namespace y la etiqueta `env: dev`.
- La etiqueta llega también a los **selectores** (`includeSelectors: true`), para que el Service de dev nunca envíe tráfico a Pods de prod.
- `kubectl kustomize` solo imprime YAML: todavía no existe nada en `lab-12`.

Pulsa **CHECK**.
