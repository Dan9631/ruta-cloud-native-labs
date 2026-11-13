Pregunta al API server quién eres y mira el kubeconfig que usa `kubectl`:

`kubectl auth whoami`{{exec}}

`kubectl config view --minify`{{exec}}

```text
ATTRIBUTE                                           VALUE
Username                                            kubernetes-admin
Groups                                              [kubeadm:cluster-admins system:authenticated]
Extra: authentication.kubernetes.io/credential-id   [X509SHA256=...]

clusters:
- cluster:
    certificate-authority-data: DATA+OMITTED
    server: https://...:6443
  name: kubernetes
...
users:
- name: kubernetes-admin
  user:
    client-certificate-data: DATA+OMITTED
    client-key-data: DATA+OMITTED
```

El kubeconfig lleva dentro tu certificado de cliente en base64. Sácalo a un archivo y ábrelo con `openssl`:

`kubectl config view --raw --minify -o jsonpath='{.users[0].user.client-certificate-data}' | base64 -d > /root/admin.crt`{{exec}}

`openssl x509 -in /root/admin.crt -noout -subject -issuer -enddate`{{exec}}

```text
subject=O = kubeadm:cluster-admins, CN = kubernetes-admin
issuer=CN = kubernetes
notAfter=...
```

**Qué observar**

- El `CN` del certificado es tu **usuario** y el `O` es tu **grupo**. Lo firmó la CA del clúster (`CN=kubernetes`).
- No existe ningún objeto «User» en Kubernetes: el API server se fía del certificado porque lo firmó su CA.
- La IP del `server` y las fechas serán distintas en tu sesión. Si tu grupo aparece como `system:masters`, este kubeconfig usa el certificado de superadministrador de kubeadm; la idea es la misma.

Pulsa **CHECK** cuando exista `/root/admin.crt`.
