Este paso es opcional y no tiene comprobación. Tiene dos partes independientes.

**Prune: borrar en Git es borrar en el clúster**

La Application tiene `prune: true`. Quita el ConfigMap del repo del reto:

`cd /root/app && git rm configmap.yaml && git commit -m "Quita gitops-config" && git push`{{exec}}

`kubectl annotate application gitops-demo -n argocd argocd.argoproj.io/refresh=normal --overwrite`{{exec}}

`sleep 10; kubectl get cm gitops-config -n lab-12`{{exec}}

```text
Error from server (NotFound): configmaps "gitops-config" not found
```

Argo CD lo ha **borrado** del clúster. Sin `prune`, el recurso quedaría huérfano y la app aparecería `OutOfSync`.

**La interfaz web de Argo CD**

La instalación core no trae `argocd-server`. La CLI de Argo CD puede levantar la interfaz en esta máquina con `argocd admin dashboard`, usando tus credenciales de `kubectl`, y servirla por HTTP. Descarga la CLI de la misma versión (unos 150-200 MB):

`curl -fsSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/download/v3.5.5/argocd-linux-amd64 && chmod +x /usr/local/bin/argocd && argocd version --client --short`{{exec}}

Arráncala en segundo plano, escuchando en todas las interfaces:

`argocd admin dashboard -n argocd --address 0.0.0.0 --port 8085 > /tmp/dashboard.log 2>&1 &`{{exec}}

`sleep 5; cat /tmp/dashboard.log`{{exec}}

Abre [la interfaz de Argo CD]({{TRAFFIC_HOST1_8085}}).

Qué mirar en la interfaz: la app `gitops-demo` con su árbol de recursos (Deployment → ReplicaSet → Pods, Service → EndpointSlice), el commit sincronizado y los botones *Refresh*, *Sync* y *History and rollback*.

En una instalación completa la interfaz la sirve `argocd-server` por HTTPS, con el usuario `admin` y una contraseña inicial que Argo CD guarda en el Secret `argocd-initial-admin-secret`. Esa contraseña se cambia tras el primer acceso (o se usa SSO) y se borra el Secret.

Para parar la interfaz:

`pkill -f 'argocd admin dashboard'`{{exec}}

Pulsa **NEXT** para terminar.
