Actualiza a una imagen que no existe:

`kubectl set image deploy/frontend nginx=nginx:9.9-noexiste -n lab-03`{{exec}}

`kubectl annotate deploy frontend -n lab-03 kubernetes.io/change-cause='version rota' --overwrite`{{exec}}

El despliegue no puede terminar. Este comando se rinde a los 25 segundos:

`kubectl rollout status deploy/frontend -n lab-03 --timeout=25s`{{exec}}

`kubectl get pods -n lab-03 -l app=frontend`{{exec}}

```text
NAME                        READY   STATUS             RESTARTS   AGE
frontend-6d8fbd8996-mrmp9   0/1     ImagePullBackOff   0          43s
frontend-75b9789595-f9cns   1/1     Running            0          2m41s
frontend-75b9789595-v7zbj   1/1     Running            0          2m37s
frontend-75b9789595-w5c98   1/1     Running            0          2m33s
```

Deshaz el cambio y revisa el historial:

`kubectl rollout undo deploy/frontend -n lab-03`{{exec}}

`kubectl rollout status deploy/frontend -n lab-03`{{exec}}

`kubectl rollout history deploy/frontend -n lab-03`{{exec}}

```text
REVISION  CHANGE-CAUSE
1         version inicial 1.27
3         version rota
4         actualizo a 1.28
```

**Qué observar**

- El rolling update **se detiene solo**: el Pod nuevo no llega a estar listo, así que no se borra ninguno de los viejos y el servicio sigue con 3 Pods de la versión 1.28.
- `rollout undo` vuelve a la plantilla anterior, que pasa a ser la **revisión 4**. La 2 desaparece porque es la misma plantilla.
- Para volver a una revisión concreta existe `kubectl rollout undo deploy/frontend --to-revision=1 -n lab-03`. No lo ejecutes ahora.

Pulsa **CHECK**.
