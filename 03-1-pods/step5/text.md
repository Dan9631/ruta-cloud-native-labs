Limpia los Pods del paso anterior:

`kubectl delete -f /root/lab/pods-ciclo-vida.yaml`{{exec}}

Crea un ReplicaSet que mantiene 3 Pods con el label `app=rs-demo`:

`cat /root/lab/replicaset.yaml`{{exec}}

`kubectl apply -f /root/lab/replicaset.yaml`{{exec}}

`kubectl get rs rs-demo -n lab-03`{{exec}}

`kubectl get pods -n lab-03 -l app=rs-demo`{{exec}}

**Autorreparación.** Borra uno de sus Pods y vuelve a listar:

`kubectl delete $(kubectl get pods -n lab-03 -l app=rs-demo -o name | head -1) -n lab-03`{{exec}}

`kubectl get pods -n lab-03 -l app=rs-demo`{{exec}}

Hay un Pod nuevo, con otro nombre y menos edad.

**Un intruso.** Crea a mano un Pod con el mismo label:

`kubectl run intruso --image=nginx:1.27-alpine --labels=app=rs-demo -n lab-03`{{exec}}

`kubectl get pods -n lab-03 -l app=rs-demo`{{exec}}

```text
NAME            READY   STATUS        RESTARTS   AGE
intruso         1/1     Terminating   0          9s
rs-demo-n7kkp   1/1     Running       0          24s
...
```

**Escalar y ver el dueño.**

`kubectl scale rs rs-demo --replicas=1 -n lab-03`{{exec}}

`kubectl get pods -n lab-03 -l app=rs-demo`{{exec}}

`kubectl get pod -n lab-03 -l app=rs-demo -o jsonpath='{.items[0].metadata.ownerReferences[0].kind}/{.items[0].metadata.ownerReferences[0].name}'; echo`{{exec}}

```text
ReplicaSet/rs-demo
```

**Qué observar**

- Al borrar un Pod aparece otro: el ReplicaSet compara lo que hay con lo que quiere y corrige la diferencia.
- El Pod `intruso` tiene el label `app=rs-demo`, así que el ReplicaSet lo cuenta como suyo, ve 4 donde quiere 3 y **borra el sobrante**. Los labels son el vínculo entre los controladores y sus Pods.
- El campo `ownerReferences` enlaza cada Pod con su ReplicaSet. Si borras el ReplicaSet, el recolector de basura borra sus Pods.

Pulsa **CHECK** con el ReplicaSet escalado a 1.
