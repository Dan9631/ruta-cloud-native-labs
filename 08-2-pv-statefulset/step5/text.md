Hay volúmenes que no guardan datos de la aplicación, sino que **inyectan** configuración. Este manifiesto crea un ConfigMap, un Secret y un Pod que monta los dos, más sus propios labels (downwardAPI), en un único volumen `projected`:

`cat /root/lab/07-projected.yaml`{{exec}}

`kubectl apply -f /root/lab/07-projected.yaml`{{exec}}

`kubectl wait --for=condition=Ready pod/proyectado -n lab-08 --timeout=90s`{{exec}}

`kubectl exec proyectado -n lab-08 -- ls /etc/app`{{exec}}

`kubectl exec proyectado -n lab-08 -- cat /etc/app/app.properties /etc/app/token /etc/app/etiquetas; echo`{{exec}}

`kubectl exec proyectado -n lab-08 -- touch /etc/app/nuevo`{{exec}}

```text
app.properties
etiquetas
token
modo=laboratorio
color=azul
no-es-un-secreto-realequipo="kcna"
touch: /etc/app/nuevo: Read-only file system
command terminated with exit code 1
```

**Qué observar**

- Tres fuentes distintas aparecen en **un único directorio**.
- `token` y `etiquetas` no terminan en salto de línea, por eso salen pegados.
- El volumen es de solo lectura: el `touch` falla.
- Así se monta también el token de la ServiceAccount en cada Pod: es un volumen projected.

Pulsa **CHECK**.
