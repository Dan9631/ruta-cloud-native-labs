Argo CD necesita un repositorio Git que vigilar. En vez de depender de un servicio externo, monta uno **dentro del clúster**: `git daemon` (protocolo `git://`, puerto 9418) en el namespace `lab-12`.

Mira el contenido inicial del repo y cómo se empaqueta:

`ls /root/lab/gitops/repo && cat /root/lab/gitops/repo/deployment.yaml`{{exec}}

`cat /root/lab/gitops/kustomization.yaml`{{exec}}

Créalo:

`kubectl apply -k /root/lab/gitops`{{exec}}

```text
configmap/git-seed-fdm2t5hb7f created
service/git-server created
deployment.apps/git-server created
```

`kubectl rollout status deploy/git-server -n lab-12 --timeout=180s`{{exec}}

`kubectl logs deploy/git-server -n lab-12 -c init-repo`{{exec}}

```text
Initialized empty Git repository in /srv/git/app.git/
...
[main (root-commit) ...] Commit inicial: gitops-web con 2 replicas
 3 files changed, ...
To /srv/git/app.git
 * [new branch]      main -> main
Repo creado
```

**Qué observar**

- Un **initContainer** crea el repo `app.git` y hace el primer commit con los archivos de `gitops/repo/`, que Kustomize empaquetó en el ConfigMap `git-seed` con `configMapGenerator` (el sufijo del nombre es un hash del contenido).
- La imagen del servidor es la propia de Argo CD, que ya trae `git` completo y ya está descargada.
- El repo vive en un `emptyDir`: si borras el Pod, vuelve al commit inicial. En el curso local va en un PVC.

Pulsa **CHECK** cuando el Deployment esté listo.
