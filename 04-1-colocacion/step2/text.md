Los selectors filtran por labels. Prueba los de igualdad, los de conjunto y los de existencia:

`kubectl get pods -n lab-04 --show-labels`{{exec}}

`kubectl get pods -n lab-04 -l tier=frontend`{{exec}}

`kubectl get pods -n lab-04 -l 'tier in (frontend,backend)'`{{exec}}

`kubectl get pods -n lab-04 -l 'tier!=frontend'`{{exec}}

`kubectl get nodes -l '!node-role.kubernetes.io/control-plane'`{{exec}}

```text
NAME                         READY   STATUS    RESTARTS   AGE   LABELS
manual                       1/1     Running   0          79s   app=manual,tier=backend
web-libre-578fcc8d4b-58nx6   1/1     Running   0          85s   app=web-libre,pod-template-hash=578fcc8d4b,tier=frontend
...
(-l tier=frontend          -> solo los 4 web-libre)
(-l 'tier in (...)'        -> los 5 Pods)
(-l 'tier!=frontend'       -> solo manual)
NAME     STATUS   ROLES    AGE   VERSION
node01   Ready    <none>   22m   v1.37.0
```

Ahora pon una label a un nodo y filtra por ella. Déjala puesta: la quitarás al empezar el paso siguiente.

`kubectl label node node01 lab-04-gpu=true`{{exec}}

`kubectl get nodes -l lab-04-gpu`{{exec}}

```text
node/node01 labeled
NAME     STATUS   ROLES    AGE   VERSION
node01   Ready    <none>   22m   v1.37.0
```

**Qué observar**

- El Deployment añadió por su cuenta la label `pod-template-hash`: la usa para distinguir sus ReplicaSets.
- El selector de existencia `!clave` excluye nodos. `controlplane` sigue teniendo la **label** `node-role.kubernetes.io/control-plane` aunque le quitamos el **taint**: son cosas distintas. La label solo describe; el taint repele Pods.
- `-l lab-04-gpu` (sin valor) también es un selector de existencia.

Pulsa **CHECK**.
