Mira la parte del kubeconfig que usa el contexto actual y la lista de contextos:

`kubectl config view --minify`{{exec}}

`kubectl config get-contexts`{{exec}}

En un clúster kubeadm el cluster suele llamarse `kubernetes` y el usuario `kubernetes-admin`, pero usa los nombres que veas tú. Guárdalos en variables:

`CLUSTER=$(kubectl config view --minify -o jsonpath='{.clusters[0].name}'); USUARIO=$(kubectl config view --minify -o jsonpath='{.users[0].name}'); echo "$CLUSTER / $USUARIO"`{{exec}}

Haz una copia completa del kubeconfig y trabaja solo sobre ella con `--kubeconfig`:

`kubectl config view --raw > /root/kubeconfig-copia.yaml`{{exec}}

`kubectl config set-context practica --cluster="$CLUSTER" --user="$USUARIO" --namespace=lab-02 --kubeconfig /root/kubeconfig-copia.yaml`{{exec}}

`kubectl config use-context practica --kubeconfig /root/kubeconfig-copia.yaml`{{exec}}

`kubectl config get-contexts --kubeconfig /root/kubeconfig-copia.yaml`{{exec}}

`kubectl get pods --kubeconfig /root/kubeconfig-copia.yaml`{{exec}}

Verás algo así, con los nombres de tu clúster:

```text
Context "practica" created.
Switched to context "practica".
CURRENT   NAME                          CLUSTER      AUTHINFO           NAMESPACE
          kubernetes-admin@kubernetes   kubernetes   kubernetes-admin
*         practica                      kubernetes   kubernetes-admin   lab-02
NAME                    READY   STATUS    RESTARTS   AGE
hola-6ddd88c97d-6w5hf   1/1     Running   0          7m3s
hola-6ddd88c97d-pbgzp   1/1     Running   0          5m54s
```

Comprueba que tu kubeconfig de trabajo no ha cambiado:

`kubectl config current-context`{{exec}}

**Qué observar**

- Un kubeconfig tiene tres listas, `clusters` (URL del API server y CA), `users` (credenciales) y `contexts` (cluster + user + namespace), y un puntero, `current-context`.
- `--minify` muestra solo lo del contexto actual y oculta los secretos (`DATA+OMITTED`). `--raw` los incluye: trata esa copia como una contraseña.
- El contexto `practica` apunta al mismo clúster y usuario, pero con namespace `lab-02` por defecto. Por eso `get pods` funciona sin `-n`.
- kubectl busca el kubeconfig en este orden: la opción `--kubeconfig`, la variable `KUBECONFIG` y `~/.kube/config`. Has usado `use-context` sin cambiar el contexto activo de tu terminal.

Pulsa **CHECK**.
