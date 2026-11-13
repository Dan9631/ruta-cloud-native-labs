Limpia el paso anterior. Quita la cuota y el LimitRange: afectarían a los pasos siguientes.

`kubectl delete deploy relleno -n lab-04 && kubectl delete pod sin-recursos -n lab-04`{{exec}}

`kubectl delete resourcequota cuota-lab -n lab-04 && kubectl delete limitrange limites-lab -n lab-04`{{exec}}

Mira los DaemonSets del propio clúster:

`kubectl get ds -n kube-system`{{exec}}

Verás `kube-proxy` y, según el plugin de red que traiga el clúster, algún DaemonSet más. Todos con `DESIRED` = 2: un Pod por nodo.

Para ver el efecto de los taints en un DaemonSet, devuelve a `controlplane` el taint que kubeadm pone por defecto:

`kubectl taint nodes controlplane node-role.kubernetes.io/control-plane:NoSchedule`{{exec}}

Ahora crea dos DaemonSets iguales, uno con la toleration de control-plane y otro sin ella:

`grep -A 3 tolerations /root/lab/14-daemonset.yaml`{{exec}}

`kubectl apply -f /root/lab/14-daemonset.yaml -f /root/lab/14b-daemonset-sin-tolerancia.yaml`{{exec}}

`kubectl rollout status ds/agente -n lab-04 && kubectl rollout status ds/agente-sin-tol -n lab-04`{{exec}}

`kubectl get ds -n lab-04`{{exec}}

`kubectl get pods -n lab-04 -o wide`{{exec}}

```text
NAME             DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR   AGE
agente           2         2         2       2            2           <none>          13s
agente-sin-tol   1         1         1       1            1           <none>          13s

NAME                   READY   STATUS    RESTARTS   AGE   IP            NODE
agente-bhkv4           1/1     Running   0          17s   10.244.1.39   node01
agente-gr7gl           1/1     Running   0          17s   10.244.0.7    controlplane
agente-sin-tol-x8k2p   1/1     Running   0          17s   10.244.1.40   node01
```

`kubectl logs ds/agente -n lab-04`{{exec}}

**Qué observar**

- `agente` tiene un Pod por nodo, **incluido `controlplane`**, gracias a la toleration `node-role.kubernetes.io/control-plane`.
- `agente-sin-tol` se queda con `DESIRED` = 1: el controlador de DaemonSet no cuenta los nodos cuyo taint no tolera. En el lab local la diferencia era 3 frente a 2.
- Los DaemonSets del sistema siguen en los 2 nodos: llevan tolerations amplias.
- El taint no ha echado a nadie: con `NoSchedule` los Pods que ya corrían en `controlplane` se quedan.

Pulsa **CHECK**. Deja el taint puesto: en el paso siguiente verás que un static Pod no lo necesita tolerar.
