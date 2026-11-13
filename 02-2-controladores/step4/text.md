Lista los tipos de objeto que conoce el clúster, sus nombres cortos y si viven en un namespace:

`kubectl api-resources | head -12`{{exec}}

`kubectl api-resources --api-group=apps`{{exec}}

`kubectl api-resources --namespaced=false | head -8`{{exec}}

```text
NAME                  SHORTNAMES   APIVERSION   NAMESPACED   KIND
controllerrevisions                apps/v1      true         ControllerRevision
daemonsets            ds           apps/v1      true         DaemonSet
deployments           deploy       apps/v1      true         Deployment
replicasets           rs           apps/v1      true         ReplicaSet
statefulsets          sts          apps/v1      true         StatefulSet
```

Mira los grupos y versiones que sirve el API server, y qué CRDs hay instalados:

`kubectl api-versions`{{exec}}

`kubectl get crd`{{exec}}

Por último, la documentación de un campo, sacada del esquema del propio clúster:

`kubectl explain deployment.spec.strategy`{{exec}}

```text
GROUP:      apps
KIND:       Deployment
VERSION:    v1

FIELD: strategy <DeploymentStrategy>
...
  type	<string>
  enum: Recreate, RollingUpdate
```

**Qué observar**

- Los nombres cortos (`cm`, `po`, `deploy`, `ds`, `sts`) sirven en cualquier comando.
- Nodes, Namespaces y PersistentVolumes **no** son namespaced: son objetos de todo el clúster.
- `apiVersion` es `grupo/versión` (`apps/v1`, `batch/v1`), salvo en el grupo core, que es solo `v1`.
- Si `kubectl get crd` lista algo, esos grupos de `api-versions` no vienen del núcleo: los añadió algún componente instalado (a menudo el propio plugin de red). En el lab local, Traefik y Gateway API añadían `traefik.io` y `gateway.networking.k8s.io`. Si sale `No resources found`, todos los grupos son del núcleo.
- `explain` lee el esquema del clúster, así que siempre coincide con su versión.

Este paso no tiene comprobación. Pulsa **NEXT**.
