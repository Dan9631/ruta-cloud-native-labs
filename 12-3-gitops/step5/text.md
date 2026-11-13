Si con `kubectl` no se puede, el cambio va por Git. Abre el acceso al servidor Git con un port-forward en segundo plano:

`kubectl port-forward -n lab-12 svc/git-server 9418:9418 > /tmp/pf-git.log 2>&1 &`{{exec}}

Clona el repo (el protocolo `git://` usa el puerto 9418 por defecto) y define tu identidad solo para este clon:

`git clone git://localhost/app.git /root/app && cd /root/app && ls`{{exec}}

`git config user.name "Alumno" && git config user.email "alumno@lab.local"`{{exec}}

Cambia la imagen, haz commit y push:

`sed -i 's/nginx:1.27-alpine/nginx:1.28-alpine/' deployment.yaml && git diff`{{exec}}

`git commit -am "Sube gitops-web a nginx 1.28" && git push`{{exec}}

```text
[main b527c14] Sube gitops-web a nginx 1.28
 1 file changed, 1 insertion(+), 1 deletion(-)
To git://localhost/app.git
   876dd25..b527c14  main -> main
```

Argo CD revisa Git cada 2-3 minutos por defecto. Para no esperar, fuerza un *refresh* (en el mundo real lo haría un webhook del servidor Git):

`kubectl annotate application gitops-demo -n argocd argocd.argoproj.io/refresh=normal --overwrite`{{exec}}

`kubectl get application gitops-demo -n argocd -o wide`{{exec}}

`kubectl get deploy gitops-web -n lab-12 -o jsonpath='{.spec.template.spec.containers[0].image}'; echo`{{exec}}

```text
NAME          SYNC STATUS   HEALTH STATUS   REVISION                                   PROJECT
gitops-demo   Synced        Progressing     b527c146f70c5b0c766b64207ff8f2f4e39a6e32   default
nginx:1.28-alpine
```

Compara el SHA de la columna `REVISION` con tu último commit:

`git log --oneline -2`{{exec}}

**Qué observar**

- La columna `REVISION` es el SHA de **tu** commit.
- `Progressing` dura lo que tarda el rolling update; luego pasa a `Healthy`.
- Volver atrás sería un `git revert` + push: el historial de Git es el historial de despliegues.

Pulsa **CHECK** cuando la app vuelva a estar `Healthy`.
