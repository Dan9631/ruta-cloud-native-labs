Borra el Pod del paso anterior:

`kubectl delete pod compartido -n lab-08`{{exec}}

Lee el PVC: pide 100Mi, `ReadWriteOnce`, de la clase `standard`. Créalo y míralo:

`cat /root/lab/02-pvc.yaml`{{exec}}

`kubectl apply -f /root/lab/02-pvc.yaml`{{exec}}

`kubectl get pvc -n lab-08`{{exec}}

`kubectl describe pvc datos -n lab-08 | grep -E 'Status|WaitForFirstConsumer'`{{exec}}

```text
NAME    STATUS    VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
datos   Pending                                      standard       <unset>                 7s

Status:        Pending
  Normal  WaitForFirstConsumer  5s (x2 over 11s)  persistentvolume-controller  waiting for first consumer to be created before binding
```

`kubectl get pv`{{exec}}

**Qué observar**

- `Pending` **no es un error**: la clase usa `WaitForFirstConsumer`.
- No existe todavía ningún PV. Se creará cuando un Pod use el PVC y el scheduler haya elegido nodo.

Pulsa **CHECK**.
