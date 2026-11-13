# Primera parte terminada

Has visto que:

- tu usuario y tu grupo salen del `CN` y el `O` de tu certificado de cliente, firmado por la CA del clúster,
- el API server autoriza con `Node,RBAC` y tiene los plugins de admisión por defecto activados,
- un Role y un RoleBinding dan permisos solo dentro de un namespace,
- para recursos de todo el clúster, como los nodos, hace falta un ClusterRole y un ClusterRoleBinding,
- `kubectl auth can-i --as=...` comprueba permisos sin tener que ser ese usuario,
- un Pod recibe un token proyectado de su ServiceAccount, con caducidad, y RBAC decide qué puede hacer con él.

La siguiente parte endurece los Pods y la red: **Módulo 05 (2 de 3) · securityContext, Pod Security y NetworkPolicies**.

El clúster de esta sesión se borra al cerrar, así que no hace falta limpiar nada.
