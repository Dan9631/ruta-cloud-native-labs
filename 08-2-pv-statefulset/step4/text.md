Borra el Pod `db-0` y mira su archivo cuando vuelva:

`kubectl delete pod db-0 -n lab-08`{{exec}}

`sleep 3; kubectl wait --for=condition=Ready pod/db-0 -n lab-08 --timeout=120s`{{exec}}

`kubectl exec db-0 -n lab-08 -- cat /var/lib/db/arranques.txt`{{exec}}

```text
db-0 arranco a las 17:03:18
db-0 arranco a las 17:03:53
```

El nuevo `db-0` tiene el mismo nombre y montó el mismo PVC, por eso ve el arranque anterior. Ahora reduce a 1 réplica:

`kubectl scale sts db -n lab-08 --replicas=1`{{exec}}

`sleep 5; kubectl get pods,pvc -n lab-08 -l app=db`{{exec}}

```text
NAME       READY   STATUS    RESTARTS   AGE
pod/db-0   1/1     Running   0          80s

NAME                               STATUS   VOLUME                                     CAPACITY
persistentvolumeclaim/datos-db-0   Bound    pvc-9691d801-cdf1-4e30-a057-304aff543124   50Mi
persistentvolumeclaim/datos-db-1   Bound    pvc-d99fecdb-68bc-4514-8967-ad3ef0b285fc   50Mi
```

**Qué observar**

- Identidad estable + almacenamiento estable: el Pod recreado se llama igual y recupera **su** PVC.
- `db-1` desapareció pero `datos-db-1` **sigue ahí**: si vuelves a escalar a 2, el nuevo `db-1` recuperará sus datos.
- Por defecto los PVCs no se borran al reducir réplicas ni al borrar el StatefulSet. Se puede cambiar con `persistentVolumeClaimRetentionPolicy`.

Pulsa **CHECK**.
