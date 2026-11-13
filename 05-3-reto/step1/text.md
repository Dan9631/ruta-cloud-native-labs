En el namespace `lab-05`, consigue lo siguiente:

1. Una ServiceAccount `despliegues` que pueda **gestionar Deployments** (get, list, watch, create, update, patch, delete) **solo** en `lab-05`, mediante un Role `gestor-deploy` y un RoleBinding `gestor-deploy`. No debe poder leer Secrets.
2. Que esa misma ServiceAccount pueda **listar nodos**, pero no borrarlos, mediante un ClusterRole `lab-05-ver-nodos` y un ClusterRoleBinding `lab-05-despliegues-nodos`.
3. El namespace `lab-05` debe seguir con el label `pod-security.kubernetes.io/enforce=restricted`.
4. Un Pod `app-segura` (imagen `busybox:1.37`, comando `sleep 3600`) que corra como **UID 2000** y con el **sistema de archivos raíz de solo lectura**, en estado `Running`. Tendrás que cumplir también el resto de requisitos de `restricted`.
5. Una NetworkPolicy `db-solo-api` que proteja a los Pods `app=db`: solo pueden recibir tráfico de Pods `app=api` en el puerto **TCP 6379**.

Comprueba tus permisos con `kubectl auth can-i ... --as=system:serviceaccount:lab-05:despliegues` antes de pulsar **CHECK**.

**Pistas**

- Para RBAC no necesitas YAML: mira `kubectl create role --help` y `kubectl create clusterrole --help`.
- Los Deployments no están en el grupo core, sino en `apps`.
- Si el Pod no cumple `restricted`, el error de creación te dice exactamente qué campo falta.
- `kubectl explain pod.spec.containers.securityContext`{{exec}}
- `kubectl explain networkpolicy.spec.ingress`{{exec}}

Cuando creas que está, pulsa **CHECK**.

**Si te atascas**

Hay una solución completa en `/root/solucion`. Inténtalo antes de mirarla:

`cat /root/solucion/pasos.txt`{{copy}}
