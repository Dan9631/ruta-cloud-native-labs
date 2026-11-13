Los nodos no pertenecen a ningún namespace. Pregunta si `lector` puede listarlos:

`kubectl auth can-i list nodes --as=system:serviceaccount:lab-05:lector`{{exec}}

```text
no
```

Un Role nunca podría dar acceso a los nodos. Hace falta un ClusterRole y un ClusterRoleBinding:

`cat /root/lab/02-clusterrole-nodos.yaml`{{exec}}

`kubectl apply -f /root/lab/02-clusterrole-nodos.yaml`{{exec}}

`kubectl auth can-i list nodes --as=system:serviceaccount:lab-05:lector`{{exec}}

`kubectl auth can-i delete nodes --as=system:serviceaccount:lab-05:lector`{{exec}}

```text
clusterrole.rbac.authorization.k8s.io/lab-05-lector-nodos created
clusterrolebinding.rbac.authorization.k8s.io/lab-05-lector-nodos created
yes
no
```

Compruébalo de verdad, actuando como la ServiceAccount:

`kubectl get nodes --as=system:serviceaccount:lab-05:lector`{{exec}}

**Qué observar**

- Los nodos son *cluster-scoped*: el permiso tiene que venir de un ClusterRole unido con un ClusterRoleBinding.
- El ClusterRole solo concede `get` y `list`, así que `delete` sigue en «no».
- Puede que `can-i` muestre el aviso `Warning: resource 'nodes' is not namespace scoped`. Aparece cuando hay un namespace en juego y es inofensivo.

Pulsa **CHECK**.
