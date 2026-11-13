Añade un label y una annotation al Pod que ya existe:

`kubectl label pod nginx env=dev -n lab-03`{{exec}}

`kubectl annotate pod nginx responsable=equipo-web -n lab-03`{{exec}}

Filtra por labels con `-l` y muéstralas como columnas con `-L`:

`kubectl get pods -n lab-03 -l 'tier=web,env=dev'`{{exec}}

`kubectl get pods -n lab-03 -L env,tier`{{exec}}

```text
NAME    READY   STATUS    RESTARTS   AGE    ENV   TIER
nginx   1/1     Running   0          101s   dev   web
```

La annotation no aparece en esas columnas. Búscala en la descripción:

`kubectl describe pod nginx -n lab-03 | grep -A3 Annotations`{{exec}}

**Qué observar**

- En `-l`, varias condiciones separadas por coma se combinan con AND.
- Las annotations guardan información para personas y herramientas, pero **no sirven para filtrar**.

Pulsa **CHECK**.
