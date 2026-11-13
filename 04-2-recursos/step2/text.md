Borra los Pods del paso anterior y crea un LimitRange:

`kubectl delete pod --all -n lab-04`{{exec}}

`kubectl apply -f /root/lab/11-limitrange.yaml`{{exec}}

`kubectl describe limitrange limites-lab -n lab-04`{{exec}}

Crea un Pod sin `resources` y mira qué le ha puesto el LimitRange:

`kubectl run sin-recursos --image=busybox:1.37 -n lab-04 -- sleep 3600`{{exec}}

`kubectl get pod sin-recursos -n lab-04 -o jsonpath='{.spec.containers[0].resources}'; echo`{{exec}}

`kubectl get pod sin-recursos -n lab-04 -o jsonpath='{.status.qosClass}'; echo`{{exec}}

```text
Type        Resource  Min  Max    Default Request  Default Limit  Max Limit/Request Ratio
----        --------  ---  ---    ---------------  -------------  -----------------------
Container   cpu       -    500m   25m              100m           -
Container   memory    -    256Mi  32Mi             64Mi           -
pod/sin-recursos created
{"limits":{"cpu":"100m","memory":"64Mi"},"requests":{"cpu":"25m","memory":"32Mi"} }
Burstable
```

Intenta crear un Pod que pide más del máximo:

`kubectl apply -f /root/lab/13-pod-gloton.yaml`{{exec}}

```text
Error from server (Forbidden): error when creating "/root/lab/13-pod-gloton.yaml": pods "gloton" is forbidden: maximum cpu usage per Container is 500m, but limit is 800m
```

Ahora la cuota del namespace (máximo 6 Pods) y un Deployment que pide 8:

`kubectl apply -f /root/lab/12-quota.yaml`{{exec}}

`kubectl describe resourcequota cuota-lab -n lab-04`{{exec}}

`kubectl create deployment relleno --image=busybox:1.37 --replicas=8 -n lab-04 -- sleep 3600`{{exec}}

`kubectl get deploy relleno -n lab-04`{{exec}}

`kubectl get events -n lab-04 --field-selector reason=FailedCreate`{{exec}}

```text
Resource         Used  Hard
--------         ----  ----
limits.cpu       100m  1
limits.memory    64Mi  1Gi
pods             1     6
requests.cpu     25m   500m
requests.memory  32Mi  512Mi

NAME      READY   UP-TO-DATE   AVAILABLE   AGE
relleno   5/8     5            5           10s

Warning   FailedCreate   replicaset/relleno-647bf94d45   Error creating: pods "relleno-647bf94d45-hgggm" is forbidden: exceeded quota: cuota-lab, requested: pods=1, used: pods=6, limited: pods=6
```

Si `relleno` aún muestra menos de 5 listos, repite el `get deploy` en unos segundos.

**Qué observar**

- El Pod sin `resources` recibió los valores por defecto del LimitRange: por eso es Burstable y no BestEffort.
- El Pod glotón ni siquiera se crea: lo rechaza el admission controller antes de llegar al scheduler.
- Con la cuota, el Deployment se queda en 5/8 (5 + `sin-recursos` = 6 Pods).
- El error aparece en los eventos del **ReplicaSet**, no del Deployment: una pista clásica de troubleshooting.

Pulsa **CHECK**. La cuota y el LimitRange se borran al empezar el paso siguiente.
