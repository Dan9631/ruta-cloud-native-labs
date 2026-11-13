Una **Application** le dice a Argo CD: «sincroniza lo que hay en este repo y ruta con este clúster y namespace». Léela:

`cat /root/lab/gitops/application.yaml`{{exec}}

Origen: `git://git-server.lab-12.svc.cluster.local/app.git` (rama `main`, raíz del repo). Destino: el namespace `lab-12` del propio clúster. Sync automático con `prune` y `selfHeal`.

Créala:

`kubectl apply -f /root/lab/gitops/application.yaml`{{exec}}

`kubectl get applications -n argocd`{{exec}}

`kubectl get deploy,svc -n lab-12 -l app=gitops-web`{{exec}}

```text
NAME          SYNC STATUS   HEALTH STATUS
gitops-demo   Synced        Healthy

NAME                         READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/gitops-web   2/2     2            2           20s

NAME                 TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
service/gitops-web   ClusterIP   10.96.254.155   <none>        80/TCP    20s
```

Si ves las columnas vacías o `Progressing`, espera unos segundos y repite: Argo CD está clonando y comparando. Si se queda en `Unknown`, el motivo está en las condiciones de la Application:

`kubectl get application gitops-demo -n argocd -o jsonpath='{.status.conditions}'; echo`{{exec}}

Mira con qué commit sincronizó y qué marca deja en lo que crea:

`kubectl get application gitops-demo -n argocd -o jsonpath='{.status.sync.revision}'; echo`{{exec}}

`kubectl get deploy gitops-web -n lab-12 -o jsonpath='{.metadata.annotations.argocd\.argoproj\.io/tracking-id}'; echo`{{exec}}

**Qué observar**

- **No ejecutaste `kubectl apply` sobre `gitops-web`**: lo creó Argo CD leyendo Git.
- `SYNC STATUS` compara Git con el clúster; `HEALTH STATUS` dice si lo desplegado funciona.
- La anotación `tracking-id` es cómo Argo CD sabe qué recursos son suyos (y cuáles borrar con `prune`).

Pulsa **CHECK** cuando la app esté `Synced` y `Healthy`.
