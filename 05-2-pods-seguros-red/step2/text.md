Pod Security Admission se configura con labels en el namespace. Antes de aplicar el perfil `restricted`, pregunta al servidor qué pasaría, sin cambiar nada:

`kubectl label --dry-run=server --overwrite ns lab-05 pod-security.kubernetes.io/enforce=restricted`{{exec}}

```text
Warning: existing pods in namespace "lab-05" violate the new PodSecurity enforce level "restricted:latest"
Warning: pod-root: allowPrivilegeEscalation != false, unrestricted capabilities, runAsNonRoot != true, seccompProfile
namespace/lab-05 labeled (server dry run)
```

Aplícalo de verdad, en modo `enforce` y `warn`, y mira los Pods que ya había:

`kubectl label --overwrite ns lab-05 pod-security.kubernetes.io/enforce=restricted pod-security.kubernetes.io/warn=restricted`{{exec}}

`kubectl get pods -n lab-05`{{exec}}

```text
NAME         READY   STATUS    RESTARTS   AGE
pod-root     1/1     Running   0          3m9s
pod-seguro   1/1     Running   0          2m58s
```

Intenta crear dos Pods inseguros: uno privilegiado y un nginx sin `securityContext`:

`cat /root/lab/06-pod-privilegiado.yaml`{{exec}}

`kubectl apply -f /root/lab/06-pod-privilegiado.yaml`{{exec}}

`kubectl run nginx-normal --image=nginx:1.27-alpine -n lab-05`{{exec}}

```text
Error from server (Forbidden): error when creating "/root/lab/06-pod-privilegiado.yaml": pods "pod-privilegiado" is forbidden: violates PodSecurity "restricted:latest": privileged (container "app" must not set securityContext.privileged=true), allowPrivilegeEscalation != false (...), unrestricted capabilities (...), runAsNonRoot != true (...), seccompProfile (...)
Error from server (Forbidden): pods "nginx-normal" is forbidden: violates PodSecurity "restricted:latest": allowPrivilegeEscalation != false (container "nginx-normal" must set securityContext.allowPrivilegeEscalation=false), unrestricted capabilities (container "nginx-normal" must set securityContext.capabilities.drop=["ALL"]), runAsNonRoot != true (...), seccompProfile (...)
```

Ahora con un Deployment:

`kubectl create deployment web-inseguro --image=nginx:1.27-alpine -n lab-05`{{exec}}

`kubectl get deploy web-inseguro -n lab-05`{{exec}}

`kubectl get events -n lab-05 --field-selector reason=FailedCreate`{{exec}}

```text
Warning: would violate PodSecurity "restricted:latest": allowPrivilegeEscalation != false (...), ...
deployment.apps/web-inseguro created
NAME           READY   UP-TO-DATE   AVAILABLE   AGE
web-inseguro   0/1     0            0           9s
LAST SEEN   TYPE      REASON         OBJECT                             MESSAGE
5s          Warning   FailedCreate   replicaset/web-inseguro-67dbcd589  Error creating: pods "web-inseguro-67dbcd589-klrnx" is forbidden: violates PodSecurity "restricted:latest": ...
```

**Qué observar**

- PSA **no toca los Pods que ya existían**: `pod-root` sigue corriendo; solo hubo un aviso.
- Los Pods nuevos que violan el perfil se rechazan con la lista exacta de lo que falta. Es la mejor guía para endurecer un manifiesto.
- Con un Deployment, el objeto se crea (con un aviso, por `warn`), pero queda en `0/1`. El motivo aparece en los eventos del ReplicaSet, que es quien intenta crear los Pods.
- `pod-seguro` cumple `restricted` porque ya llevaba todo lo necesario.

Pulsa **CHECK**.
