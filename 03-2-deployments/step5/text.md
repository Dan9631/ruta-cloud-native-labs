Borra el Deployment del paso anterior:

`kubectl delete -f /root/api.yaml`{{exec}}

Lee el manifiesto. Define un ConfigMap, un Secret y un Pod que los consume de dos formas: como variables de entorno y como archivos.

`cat /root/lab/config.yaml`{{exec}}

`kubectl apply -f /root/lab/config.yaml`{{exec}}

`kubectl wait --for=condition=Ready pod/consume-config -n lab-03 --timeout=90s`{{exec}}

**Como variables de entorno:**

`kubectl exec consume-config -n lab-03 -- env | grep -E 'COLOR|APP_|DB_'`{{exec}}

```text
DB_PASSWORD=S3cr3t0-de-lab
APP_COLOR=azul
APP_MODE=desarrollo
COLOR=azul
```

**Como archivos:**

`kubectl exec consume-config -n lab-03 -- ls /etc/app /etc/secreto`{{exec}}

`kubectl exec consume-config -n lab-03 -- cat /etc/app/app.properties`{{exec}}

**Cómo se guarda el Secret:**

`kubectl get secret app-secret -n lab-03 -o jsonpath='{.data.DB_PASSWORD}'; echo`{{exec}}

`kubectl get secret app-secret -n lab-03 -o jsonpath='{.data.DB_PASSWORD}' | base64 -d; echo`{{exec}}

```text
UzNjcjN0MC1kZS1sYWI=
S3cr3t0-de-lab
```

**Qué observar**

- `COLOR` viene de una clave concreta (`configMapKeyRef`); `APP_COLOR` y `APP_MODE` vienen de `envFrom`, que trae todas las claves.
- En el volumen, **cada clave es un archivo**.
- El Secret se escribió en texto plano con `stringData` y se guarda en base64. Lo decodificaste con un comando: **base64 es codificación, no cifrado**.

Pulsa **CHECK**.
