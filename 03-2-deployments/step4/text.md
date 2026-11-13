Hasta ahora has dado órdenes: crea, cambia la imagen, deshaz. La forma declarativa es guardar el estado deseado en un archivo y pedir a Kubernetes que lo alcance.

Genera un manifiesto y aplícalo:

`kubectl create deployment api --image=nginx:1.27-alpine --replicas=2 -n lab-03 --dry-run=client -o yaml > /root/api.yaml`{{exec}}

`kubectl apply -f /root/api.yaml`{{exec}}

El apply clásico guarda lo último que aplicaste en una annotation:

`kubectl get deploy api -n lab-03 -o jsonpath='{.metadata.annotations.kubectl\.kubernetes\.io/last-applied-configuration}'; echo`{{exec}}

Cambia las réplicas en el archivo y aplica dos veces seguidas:

`sed -i 's/replicas: 2/replicas: 4/' /root/api.yaml`{{exec}}

`kubectl apply -f /root/api.yaml`{{exec}}

`kubectl apply -f /root/api.yaml`{{exec}}

```text
deployment.apps/api configured
deployment.apps/api unchanged
```

`kubectl get deploy api -n lab-03`{{exec}}

Por último, aplica el mismo archivo con server-side apply:

`kubectl apply --server-side --force-conflicts -f /root/api.yaml`{{exec}}

```text
deployment.apps/api serverside-applied
```

**Qué observar**

- El primer `apply` crea, el segundo detecta el cambio (`configured`) y el tercero no hace nada (`unchanged`): es **idempotente**.
- La annotation `last-applied-configuration` es la memoria del apply clásico.
- Con `--server-side`, quien calcula los cambios es el API server y la propiedad de cada campo queda en `metadata.managedFields`. `--force-conflicts` toma la propiedad de los campos que gestionaba el apply clásico.

Pulsa **CHECK**.
