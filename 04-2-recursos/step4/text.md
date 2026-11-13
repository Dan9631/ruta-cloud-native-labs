Borra los DaemonSets del paso anterior. El taint de `controlplane` se queda puesto de momento.

`kubectl delete ds agente agente-sin-tol -n lab-04`{{exec}}

La terminal de este escenario corre en `controlplane`. Mira los static Pods que arrancan el plano de control:

`ls /etc/kubernetes/manifests`{{exec}}

```text
etcd.yaml  kube-apiserver.yaml  kube-controller-manager.yaml  kube-scheduler.yaml
```

Crea uno tuyo copiando un manifiesto a esa carpeta. No hay `kubectl apply`: lo arranca el kubelet de `controlplane` al ver el archivo.

`cat /root/lab/15-static-pod.yaml`{{exec}}

`cp /root/lab/15-static-pod.yaml /etc/kubernetes/manifests/lab-04-estatico.yaml`{{exec}}

`sleep 20; kubectl get pods -n lab-04 -o wide`{{exec}}

`kubectl get pod estatico-controlplane -n lab-04 -o jsonpath='{.metadata.ownerReferences[0].kind}/{.metadata.ownerReferences[0].name}'; echo`{{exec}}

```text
NAME                    READY   STATUS    RESTARTS   AGE   IP           NODE
estatico-controlplane   1/1     Running   0          17s   10.244.0.41  controlplane
Node/controlplane
```

Si todavía no aparece, repite el `get pods` en unos segundos.

Intenta borrarlo con kubectl:

`kubectl delete pod estatico-controlplane -n lab-04`{{exec}}

`sleep 5; kubectl get pods -n lab-04`{{exec}}

```text
pod "estatico-controlplane" deleted from lab-04 namespace
NAME                    READY   STATUS    RESTARTS   AGE
estatico-controlplane   1/1     Running   0          4s
```

**Qué observar**

- El nombre lleva el sufijo del nodo y su «dueño» es el **Node**, no un ReplicaSet.
- Ha arrancado en `controlplane` aunque el nodo tiene un taint `NoSchedule` y el Pod no lo tolera: los taints los aplica el scheduler, y un static Pod no pasa por él.
- Al borrarlo con kubectl reaparece enseguida: solo borraste el *mirror pod*, la copia de solo lectura que el kubelet publica en el API server.
- Así funcionan etcd, el API server y el scheduler de este clúster.

Pulsa **CHECK** con el static Pod en marcha. Lo borrarás «de verdad» al empezar el paso siguiente.
