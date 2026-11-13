Cambia la imagen del contenedor. Eso modifica la plantilla de Pod y dispara un rolling update:

`kubectl set image deploy/frontend nginx=nginx:1.28-alpine -n lab-03`{{exec}}

`kubectl annotate deploy frontend -n lab-03 kubernetes.io/change-cause='actualizo a 1.28' --overwrite`{{exec}}

`kubectl rollout status deploy/frontend -n lab-03`{{exec}}

Ahora hay dos ReplicaSets y dos entradas en el historial:

`kubectl get rs -n lab-03 -l app=frontend`{{exec}}

`kubectl rollout history deploy/frontend -n lab-03`{{exec}}

```text
REVISION  CHANGE-CAUSE
1         version inicial 1.27
2         actualizo a 1.28
```

Los eventos cuentan cómo se hizo el cambio:

`kubectl get events -n lab-03 --field-selector involvedObject.kind=Deployment --sort-by=.lastTimestamp`{{exec}}

```text
Scaled up replica set frontend-75b9789595 from 0 to 1
Scaled down replica set frontend-8558b67b76 from 3 to 2
Scaled up replica set frontend-75b9789595 from 1 to 2
Scaled down replica set frontend-8558b67b76 from 2 to 1
...
```

**Qué observar**

- Los eventos muestran el baile **+1 nuevo / −1 viejo**: con 3 réplicas, el 25 % se traduce en 1 Pod de más y 0 de menos.
- El ReplicaSet viejo queda con 0 réplicas en vez de borrarse: es lo que permite el rollback.

Pulsa **CHECK**.
