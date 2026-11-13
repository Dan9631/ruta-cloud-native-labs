Descarga el manifiesto oficial de Argo CD **core**, con la misma versión que fija el curso (v3.5.5):

`curl -fsSL -o /root/argocd-core.yaml https://raw.githubusercontent.com/argoproj/argo-cd/v3.5.5/manifests/core-install.yaml && ls -lh /root/argocd-core.yaml`{{exec}}

Mira qué componentes trae y qué imágenes usa:

`awk '/^kind: (Deployment|StatefulSet)$/ {k=$2} k && /^  name:/ {print k, $2; k=""}' /root/argocd-core.yaml`{{exec}}

```text
Deployment argocd-applicationset-controller
Deployment argocd-redis
Deployment argocd-repo-server
StatefulSet argocd-application-controller
```

`grep -oE 'image: [^ ]+' /root/argocd-core.yaml | sort -u`{{exec}}

```text
image: public.ecr.aws/docker/library/redis:8.2.3-alpine
image: quay.io/argoproj/argocd:v3.5.5
```

Aplícalo en su namespace. Los CRDs de Argo CD son muy grandes para el `apply` normal, por eso se usa `--server-side`:

`kubectl create namespace argocd`{{exec}}

`kubectl apply -n argocd --server-side --force-conflicts -f /root/argocd-core.yaml | tail -3`{{exec}}

Este laboratorio no usa ApplicationSets, así que apaga su controlador para ahorrar memoria. Después declara el proyecto `default`, que el manifiesto core no incluye:

`kubectl -n argocd scale deploy argocd-applicationset-controller --replicas=0`{{exec}}

`kubectl wait --for condition=established crd/appprojects.argoproj.io --timeout=60s && kubectl apply -f /root/lab/gitops/appproject-default.yaml`{{exec}}

Espera a los tres componentes (la primera descarga puede tardar 2-4 minutos):

```bash
kubectl -n argocd rollout status deploy/argocd-redis --timeout=300s
kubectl -n argocd rollout status deploy/argocd-repo-server --timeout=300s
kubectl -n argocd rollout status statefulset/argocd-application-controller --timeout=300s
kubectl -n argocd get pods
```{{exec}}

```text
NAME                                  READY   STATUS    RESTARTS   AGE
argocd-application-controller-0       1/1     Running   0          2m
argocd-redis-...                      1/1     Running   0          2m
argocd-repo-server-...                1/1     Running   0          2m
```

Si algún Pod se queda en `ImagePullBackOff` o `Pending`, mira el motivo con `kubectl -n argocd describe pod <nombre> | tail -15`{{copy}}.

**Qué observar**

- En un clúster con internet basta con crear el namespace y aplicar el manifiesto oficial con la versión fijada. El manifiesto completo (`install.yaml`) añade `argocd-server` (API e interfaz web), Dex para SSO y el controlador de notificaciones.
- El **application-controller** es el que compara el estado deseado con el real y sincroniza. El **repo-server** clona Git y renderiza los manifiestos (YAML plano, Kustomize o Helm). Redis es su caché.
- Nada de esto expone puertos fuera del clúster: Argo CD **tira** de Git (modelo *pull*), nadie le empuja cambios.

Pulsa **CHECK** cuando los tres Pods estén `Running`.
