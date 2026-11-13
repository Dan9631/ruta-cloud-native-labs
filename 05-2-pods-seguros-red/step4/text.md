Crea un Secret y mira cómo lo devuelve la API:

`kubectl create secret generic db-cred --from-literal=usuario=app --from-literal=password=NoSoyCifrado123 -n lab-05`{{exec}}

`kubectl get secret db-cred -n lab-05 -o jsonpath='{.data.password}'; echo`{{exec}}

`kubectl get secret db-cred -n lab-05 -o jsonpath='{.data.password}' | base64 -d; echo`{{exec}}

```text
secret/db-cred created
Tm9Tb3lDaWZyYWRvMTIz
NoSoyCifrado123
```

¿Puede leerlo la ServiceAccount `lector`, que solo tiene permisos sobre Pods?

`kubectl auth can-i get secrets -n lab-05 --as=system:serviceaccount:lab-05:lector`{{exec}}

```text
no
```

Ahora mira cómo queda guardado en etcd. etcd corre como static Pod en `controlplane` y su imagen trae `etcdctl`:

`ETCD=$(kubectl get pods -n kube-system -l component=etcd -o name | head -1); echo $ETCD`{{exec}}

`kubectl exec -n kube-system $ETCD -- etcdctl --endpoints=https://127.0.0.1:2379 --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/server.crt --key=/etc/kubernetes/pki/etcd/server.key get /registry/secrets/lab-05/db-cred --print-value-only | grep -a -o 'NoSoyCifrado123'`{{exec}}

```text
pod/etcd-controlplane
NoSoyCifrado123
```

Comprueba si el API server tiene configurado el cifrado en reposo:

`grep -c encryption-provider-config /etc/kubernetes/manifests/kube-apiserver.yaml`{{exec}}

```text
0
```

**Qué observar**

- Decodificar base64 es inmediato: base64 es una codificación, no un cifrado.
- La protección real de un Secret es **RBAC** (la ServiceAccount `lector` no puede leerlo) y el **cifrado en reposo**.
- Si `grep` encontró la contraseña en el valor guardado en etcd, el Secret está en claro: quien tenga acceso a etcd o a sus copias de seguridad tiene tus secretos. En producción se configura `EncryptionConfiguration` (idealmente con un proveedor KMS) y el API server lo carga con `--encryption-provider-config`.

Pulsa **CHECK**.
