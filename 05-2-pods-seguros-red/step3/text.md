Limpia lo que sobra del paso anterior:

`kubectl delete deploy web-inseguro -n lab-05`{{exec}}

`kubectl delete pod pod-root -n lab-05`{{exec}}

Una NetworkPolicy es solo un objeto en la API: quien la hace cumplir es el **plugin de red (CNI)** del clúster, y no todos lo hacen. Mira cuál tiene este:

`ls /etc/cni/net.d/`{{exec}}

`kubectl get pods -n kube-system -o wide | grep -Ei 'calico|cilium|flannel|canal|weave|kindnet'`{{exec}}

El escenario: un servidor `api` (label `app=api`, sirve una página en el puerto 8080, con su Service `api` en el 80), un cliente `frontend` (`role=frontend`) y un cliente `intruso` (`role=otro`). Todos cumplen el perfil `restricted`.

`cat /root/lab/07-np-app.yaml`{{exec}}

`kubectl apply -f /root/lab/07-np-app.yaml`{{exec}}

`kubectl wait --for=condition=Ready pod/api pod/frontend pod/intruso -n lab-05 --timeout=90s`{{exec}}

`kubectl exec -n lab-05 frontend -- wget -qO- -T 3 http://api`{{exec}}

`kubectl exec -n lab-05 intruso -- wget -qO- -T 3 http://api`{{exec}}

```text
hola-desde-api
hola-desde-api
```

Sin políticas, todo el mundo entra. Aplica el **default deny** de entrada y repite las dos peticiones:

`cat /root/lab/08-np-default-deny.yaml`{{exec}}

`kubectl apply -f /root/lab/08-np-default-deny.yaml`{{exec}}

`kubectl exec -n lab-05 frontend -- wget -qO- -T 3 http://api`{{exec}}

`kubectl exec -n lab-05 intruso -- wget -qO- -T 3 http://api`{{exec}}

```text
wget: download timed out
command terminated with exit code 1
wget: download timed out
command terminated with exit code 1
```

Abre el hueco solo para `role=frontend`:

`cat /root/lab/09-np-permitir-frontend.yaml`{{exec}}

`kubectl apply -f /root/lab/09-np-permitir-frontend.yaml`{{exec}}

`kubectl exec -n lab-05 frontend -- wget -qO- -T 3 http://api`{{exec}}

`kubectl exec -n lab-05 intruso -- wget -qO- -T 3 http://api`{{exec}}

`kubectl describe networkpolicy permitir-frontend -n lab-05`{{exec}}

```text
hola-desde-api
wget: download timed out
command terminated with exit code 1

Name:         permitir-frontend
Namespace:    lab-05
...
Spec:
  PodSelector:     app=api
  Allowing ingress traffic:
    To Port: 8080/TCP
    From:
      PodSelector: role=frontend
  Not affecting egress traffic
  Policy Types: Ingress
```

**Comprueba el efecto real.** Si después del default deny `frontend` e `intruso` siguen recibiendo `hola-desde-api`, el plugin de red de este clúster no aplica NetworkPolicies: los objetos se guardan, pero nadie los hace cumplir. Kubernetes no da ningún error en ese caso. Es una lección en sí misma: antes de fiarte de una NetworkPolicy, comprueba que tu CNI la implementa.

**Qué observar**

- Con el default deny, el tráfico no se rechaza con un error: los paquetes se descartan y el cliente agota el tiempo (*timed out*).
- Las dos políticas se suman: el default deny cierra todo y `permitir-frontend` abre solo `frontend → api:8080`.
- El puerto de la política es el del **contenedor** (8080), no el del Service (80).
- La resolución DNS de `api` siguió funcionando porque solo se restringió la entrada (*ingress*) en `lab-05`.

Pulsa **CHECK**.
