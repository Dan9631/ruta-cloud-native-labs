Crea un Deployment con 3 réplicas y espera a que termine de desplegarse:

`kubectl create deployment frontend --image=nginx:1.27-alpine --replicas=3 -n lab-03`{{exec}}

`kubectl rollout status deploy/frontend -n lab-03`{{exec}}

Mira los tres niveles que se han creado:

`kubectl get deploy,rs,pods -n lab-03 -l app=frontend`{{exec}}

```text
NAME                       READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/frontend   3/3     3            3           7s

NAME                                  DESIRED   CURRENT   READY   AGE
replicaset.apps/frontend-8558b67b76   3         3         3       7s

NAME                            READY   STATUS    RESTARTS   AGE
pod/frontend-8558b67b76-5dwkf   1/1     Running   0          7s
...
```

Anota el motivo del cambio, que luego aparecerá en el historial, y consulta la estrategia de actualización:

`kubectl annotate deploy frontend -n lab-03 kubernetes.io/change-cause='version inicial 1.27'`{{exec}}

`kubectl get deploy frontend -n lab-03 -o jsonpath='{.spec.strategy}'; echo`{{exec}}

```text
{"rollingUpdate":{"maxSurge":"25%","maxUnavailable":"25%"},"type":"RollingUpdate"}
```

**Qué observar**

- La cadena de nombres: `frontend` → `frontend-8558b67b76` (hash de la plantilla de Pod) → `frontend-8558b67b76-5dwkf`. El Deployment crea un ReplicaSet y el ReplicaSet crea los Pods.
- La estrategia por defecto es RollingUpdate con 25 % / 25 %.

Pulsa **CHECK**.
