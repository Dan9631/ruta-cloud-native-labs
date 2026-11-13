Antes de crear nada, mira qué labels y taints tienen los nodos. Con eso puedes predecir dónde caerá cada Pod.

`kubectl get nodes -L disktype,zone`{{exec}}

`kubectl get nodes -o custom-columns='NODO:.metadata.name,TAINTS:.spec.taints[*].key'`{{exec}}

`kubectl describe node controlplane | grep Taints`{{exec}}

```text
NAME           STATUS   ROLES           AGE   VERSION   DISKTYPE   ZONE
controlplane   Ready    control-plane   20m   v1.37.0   ssd        zona-a
node01         Ready    <none>          19m   v1.37.0   hdd        zona-b

NODO           TAINTS
controlplane   <none>
node01         <none>

Taints:             <none>
```

En un clúster kubeadm recién instalado, `controlplane` tendría el taint `node-role.kubernetes.io/control-plane:NoSchedule`. Lo ha quitado el arranque del escenario con este comando (no hace falta que lo ejecutes):

`kubectl taint nodes controlplane node-role.kubernetes.io/control-plane:NoSchedule-`{{copy}}

Ahora crea un Deployment sin ninguna regla de scheduling y un Pod con `nodeName`:

`cat /root/lab/02-pod-manual.yaml`{{exec}}

`kubectl apply -f /root/lab/01-web-libre.yaml -f /root/lab/02-pod-manual.yaml`{{exec}}

`kubectl rollout status deploy/web-libre -n lab-04`{{exec}}

`kubectl get pods -n lab-04 -o wide`{{exec}}

```text
NAME                         READY   STATUS    RESTARTS   AGE   IP           NODE
manual                       1/1     Running   0          12s   10.244.1.5   node01
web-libre-578fcc8d4b-58nx6   1/1     Running   0          12s   10.244.0.6   controlplane
web-libre-578fcc8d4b-qnv5q   1/1     Running   0          12s   10.244.1.4   node01
web-libre-578fcc8d4b-trd2l   1/1     Running   0          12s   10.244.1.6   node01
web-libre-578fcc8d4b-v5kcz   1/1     Running   0          12s   10.244.0.7   controlplane
```

Tu reparto puede no ser 2 y 2: `controlplane` ya tiene CPU y memoria reservadas por los componentes del plano de control, y el scheduler tiene eso en cuenta al puntuar.

Compara quién decidió cada caso:

`kubectl get events -n lab-04 --field-selector reason=Scheduled`{{exec}}

`kubectl get events -n lab-04 --field-selector involvedObject.name=manual`{{exec}}

```text
REASON      OBJECT                           MESSAGE
Scheduled   pod/web-libre-578fcc8d4b-58nx6   Successfully assigned lab-04/web-libre-578fcc8d4b-58nx6 to controlplane
...
REASON    OBJECT       MESSAGE
Pulled    pod/manual   Container image "nginx:1.27-alpine" ...
Created   pod/manual   Container created
Started   pod/manual   Container started
```

**Qué observar**

- Las 4 réplicas de `web-libre` se reparten entre los dos nodos. En el lab local ninguna caía en el plano de control por su taint; aquí sí, porque se lo hemos quitado.
- Cada réplica tiene un evento `Scheduled` del `default-scheduler`.
- El Pod `manual` **no tiene evento `Scheduled`**: el scheduler nunca intervino porque ya traía `nodeName: node01`.

Pulsa **CHECK**.
