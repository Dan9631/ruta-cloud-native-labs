El Pod `cliente-api` usa `serviceAccountName: lector` y tiene `curl`. Créalo y mira el volumen que Kubernetes le añade:

`cat /root/lab/03-pod-cliente-api.yaml`{{exec}}

`kubectl apply -f /root/lab/03-pod-cliente-api.yaml`{{exec}}

`kubectl wait --for=condition=Ready pod/cliente-api -n lab-05 --timeout=90s`{{exec}}

`kubectl get pod cliente-api -n lab-05 -o jsonpath='{.spec.volumes[0].projected.sources[0]}'; echo`{{exec}}

`kubectl exec -n lab-05 cliente-api -- ls /var/run/secrets/kubernetes.io/serviceaccount`{{exec}}

```text
{"serviceAccountToken":{"expirationSeconds":3607,"path":"token"} }
ca.crt
namespace
token
```

Usa ese token para llamar a la API desde dentro del Pod. La variable `SA` está definida en el Pod y apunta a esa carpeta:

`kubectl exec -n lab-05 cliente-api -- sh -c 'curl -s -o /dev/null -w "%{http_code}\n" --cacert $SA/ca.crt --oauth2-bearer $(cat $SA/token) https://kubernetes.default.svc/api/v1/namespaces/lab-05/pods'`{{exec}}

`kubectl exec -n lab-05 cliente-api -- sh -c 'curl -s --cacert $SA/ca.crt --oauth2-bearer $(cat $SA/token) https://kubernetes.default.svc/api/v1/namespaces/lab-05/secrets'`{{exec}}

`kubectl exec -n lab-05 cliente-api -- sh -c 'curl -s https://kubernetes.default.svc/version'`{{exec}}

```text
200
{
  "kind": "Status",
  "apiVersion": "v1",
  "status": "Failure",
  "message": "secrets is forbidden: User \"system:serviceaccount:lab-05:lector\" cannot list resource \"secrets\" in API group \"\" in the namespace \"lab-05\"",
  "reason": "Forbidden",
  "code": 403
}
command terminated with exit code 60
```

Por último, mira qué lleva dentro un token. Es un JWT: tres partes en base64url separadas por puntos. Este bloque decodifica la parte central:

```
t=$(kubectl create token lector -n lab-05 --duration=10m)
p=$(echo "$t" | cut -d. -f2 | tr '_-' '/+')
while [ $(( ${#p} % 4 )) -ne 0 ]; do p="$p="; done
echo "$p" | base64 -d; echo
```{{exec}}

`kubectl get secrets -n lab-05`{{exec}}

```text
{"aud":["https://kubernetes.default.svc.cluster.local"],"exp":...,"iat":...,"iss":"https://kubernetes.default.svc.cluster.local",...,"kubernetes.io":{"namespace":"lab-05","serviceaccount":{"name":"lector",...} },...,"sub":"system:serviceaccount:lab-05:lector"}
No resources found in lab-05 namespace.
```

**Qué observar**

- El Pod llega al API server con el token montado automáticamente, y RBAC le responde `200` para Pods y `403` para Secrets.
- Sin `--cacert`, curl falla con el código 60: no puede verificar el certificado del servidor. El `ca.crt` montado es justo la CA del clúster.
- El token tiene emisor (`iss`), sujeto (`sub`), audiencia (`aud`) y caducidad (`exp`).
- No hay ningún Secret con tokens en el namespace: desde Kubernetes 1.24 ya no se crean solos.

Pulsa **CHECK**.
