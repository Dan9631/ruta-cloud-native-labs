Mira el historial del release y dónde lo guarda Helm:

`helm history saludo -n lab-12`{{exec}}

```text
REVISION  UPDATED   STATUS      CHART         APP VERSION  DESCRIPTION
1         ...       superseded  saludo-0.1.0  1.27         Install complete
2         ...       deployed    saludo-0.1.0  1.27         Upgrade complete
```

`kubectl get secrets -n lab-12 -l owner=helm -L status,version`{{exec}}

```text
NAME                           TYPE                 DATA   AGE   STATUS       VERSION
sh.helm.release.v1.saludo.v1   helm.sh/release.v1   1      2m    superseded   1
sh.helm.release.v1.saludo.v2   helm.sh/release.v1   1      1m    deployed     2
```

Ahora vuelve a la revisión 1:

`helm rollback saludo 1 -n lab-12`{{exec}}

```text
Rollback was a success! Happy Helming!
```

`helm history saludo -n lab-12`{{exec}}

```text
REVISION  UPDATED   STATUS      CHART         APP VERSION  DESCRIPTION
1         ...       superseded  saludo-0.1.0  1.27         Install complete
2         ...       superseded  saludo-0.1.0  1.27         Upgrade complete
3         ...       deployed    saludo-0.1.0  1.27         Rollback to 1
```

`kubectl rollout status deploy/saludo -n lab-12`{{exec}}

`kubectl exec deploy/saludo -n lab-12 -- wget -qO- http://localhost/`{{exec}}

**Qué observar**

- Cada revisión es un **Secret** en el namespace del release. No hay ningún componente de Helm corriendo en el clúster (en Helm 2 existía Tiller).
- El rollback **no borra** la revisión 2: crea una **revisión 3** con el contenido de la 1. El historial siempre avanza, igual que un `git revert`.
- El Deployment vuelve a 1 réplica con `nginx:1.27-alpine` y la página vuelve a decir *v1*.

Pulsa **CHECK**.
