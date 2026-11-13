Lee el manifiesto: un Service headless `db` y un StatefulSet `db` de 2 réplicas con una `volumeClaimTemplates` llamada `datos` (50Mi de la clase `standard`). Cada réplica anota en **su** volumen su nombre y la hora a la que arrancó.

`cat /root/lab/06-statefulset.yaml`{{exec}}

`kubectl apply -f /root/lab/06-statefulset.yaml`{{exec}}

`kubectl rollout status sts/db -n lab-08 --timeout=180s`{{exec}}

`kubectl get pods -n lab-08 -l app=db -o wide`{{exec}}

`kubectl get pvc -n lab-08`{{exec}}

```text
NAME   READY   STATUS    RESTARTS   AGE   IP            NODE
db-0   1/1     Running   0          28s   <ip>           node01
db-1   1/1     Running   0          14s   <ip>           node01

NAME           STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS
claim-manual   Bound    lab-08-pv-manual                           200Mi      RWO            lab-08-manual
datos-db-0     Bound    pvc-9691d801-cdf1-4e30-a057-304aff543124   50Mi       RWO            standard
datos-db-1     Bound    pvc-d99fecdb-68bc-4514-8967-ad3ef0b285fc   50Mi       RWO            standard
```

`kubectl exec db-0 -n lab-08 -- cat /var/lib/db/arranques.txt`{{exec}}

`kubectl exec db-1 -n lab-08 -- cat /var/lib/db/arranques.txt`{{exec}}

```text
db-0 arranco a las 17:03:18
db-1 arranco a las 17:03:29
```

**Qué observar**

- Los Pods se crean **en orden**: primero `db-0` y, cuando está listo, `db-1`.
- Cada uno tiene **su** PVC, generado desde la plantilla con el nombre `<plantilla>-<statefulset>-<ordinal>`: `datos-db-0`, `datos-db-1`.
- Aquí las dos réplicas caen en `node01` porque es el único nodo sin taint. En el clúster del curso, con dos workers, pueden repartirse entre nodos, y cada PV queda atado al nodo donde se creó.

Pulsa **CHECK**.
