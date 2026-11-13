El chart `saludo` está escrito a mano y es más simple que el que genera `helm create`. Tiene `Chart.yaml`, `values.yaml` y `templates/` con un ConfigMap (la página HTML), un Deployment y un Service.

`find /root/lab/helm -type f | sort`{{exec}}

`cat /root/lab/helm/saludo/Chart.yaml /root/lab/helm/saludo/values.yaml`{{exec}}

`cat /root/lab/helm/saludo/templates/configmap.yaml`{{exec}}

En las plantillas, lo que va entre llaves dobles se sustituye al renderizar: `.Release.Name` es el nombre del release y `.Values.mensaje` sale de `values.yaml`.

Renderiza el chart sin tocar el clúster. Guárdalo en `/root/saludo.yaml` y mira el principio:

`helm template saludo /root/lab/helm/saludo > /root/saludo.yaml && head -16 /root/saludo.yaml`{{exec}}

```text
---
# Source: saludo/templates/configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: saludo-html
  labels:
    app.kubernetes.io/name: saludo
    app.kubernetes.io/instance: saludo
...
data:
  index.html: |
    <h1>Hola desde Helm (v1)</h1>
```

**Qué observar**

- `helm template` muestra el YAML final **sin tocar el clúster**.
- El nombre del release se convirtió en `saludo` y el mensaje, en el texto de `values.yaml`.
- Es también lo que hace Argo CD por dentro con los charts: los renderiza y aplica el resultado.

Pulsa **CHECK**.
