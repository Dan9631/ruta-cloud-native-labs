Este clúster es de kubeadm: los certificados del plano de control están en `controlplane`, en `/etc/kubernetes/pki`. Míralos:

`ls /etc/kubernetes/pki /etc/kubernetes/pki/etcd`{{exec}}

```text
/etc/kubernetes/pki:
apiserver-etcd-client.crt     apiserver-kubelet-client.crt  apiserver.crt  ca.crt  etcd
front-proxy-ca.crt  front-proxy-client.crt  sa.key  sa.pub  ...
```

Abre el certificado del API server y fíjate en sus nombres alternativos (SAN):

`openssl x509 -in /etc/kubernetes/pki/apiserver.crt -noout -subject -issuer -ext subjectAltName`{{exec}}

```text
subject=CN = kube-apiserver
issuer=CN = kubernetes
X509v3 Subject Alternative Name:
    DNS:controlplane, DNS:kubernetes, DNS:kubernetes.default, DNS:kubernetes.default.svc,
    DNS:kubernetes.default.svc.cluster.local, IP Address:10.96.0.1, IP Address:...
```

Mira cómo arranca el API server. Es un static Pod y su manifiesto está en el nodo:

`grep -E 'authorization|admission-plugins|client-ca-file' /etc/kubernetes/manifests/kube-apiserver.yaml`{{exec}}

```text
    - --authorization-mode=Node,RBAC
    - --client-ca-file=/etc/kubernetes/pki/ca.crt
    - --enable-admission-plugins=NodeRestriction
    - --requestheader-client-ca-file=/etc/kubernetes/pki/front-proxy-ca.crt
```

Por último, los API groups. Primero los recursos de RBAC y después todas las versiones que sirve el API server:

`kubectl api-resources --api-group=rbac.authorization.k8s.io`{{exec}}

`kubectl api-versions`{{exec}}

```text
NAME                  SHORTNAMES   APIVERSION                     NAMESPACED   KIND
clusterrolebindings                rbac.authorization.k8s.io/v1   false        ClusterRoleBinding
clusterroles                       rbac.authorization.k8s.io/v1   false        ClusterRole
rolebindings                       rbac.authorization.k8s.io/v1   true         RoleBinding
roles                              rbac.authorization.k8s.io/v1   true         Role
```

**Qué observar**

- `ca.crt` y `ca.key` son la raíz de confianza. `apiserver-etcd-client` y `apiserver-kubelet-client` son los certificados con los que el API server actúa como **cliente** de etcd y de los kubelets. `sa.key` y `sa.pub` firman y verifican los tokens de ServiceAccount. etcd tiene su propia CA en la carpeta `etcd`.
- Los SAN del API server incluyen `kubernetes.default.svc`: es el nombre que usan los Pods para llegar a él. La IP `10.96.0.1` (o la primera del rango de Services de tu clúster) es la del Service `kubernetes`.
- La autorización está en modo `Node,RBAC`. `NodeRestriction` es el único plugin de admisión añadido a mano; los de por defecto, como `PodSecurity`, `LimitRanger` o `ServiceAccount`, ya vienen activados.
- Role y RoleBinding son *namespaced*; ClusterRole y ClusterRoleBinding no. El grupo core aparece en `api-versions` simplemente como `v1`. Si ves grupos de addons (por ejemplo del plugin de red), es que añaden sus propios recursos con CRDs.

Este paso no tiene comprobación. Pulsa **NEXT**.
