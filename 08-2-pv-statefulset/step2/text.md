Borra el Pod y el PVC, y mira en qué queda el PV:

`kubectl delete pod app-manual -n lab-08`{{exec}}

`kubectl delete pvc claim-manual -n lab-08`{{exec}}

`kubectl get pv lab-08-pv-manual`{{exec}}

`ssh node01 ls /tmp/lab-08-pv`{{exec}}

```text
NAME               CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS     CLAIM                 STORAGECLASS
lab-08-pv-manual   200Mi      RWO            Retain           Released   lab-08/claim-manual   lab-08-manual
saludo.txt
```

Con `Retain` el PV queda **Released** y los datos siguen en el disco. Vuelve a crear el PVC:

`kubectl apply -f /root/lab/04-pv-estatico.yaml`{{exec}}

`kubectl get pvc claim-manual -n lab-08`{{exec}}

```text
NAME           STATUS    VOLUME   CAPACITY   ...
claim-manual   Pending                       ...
```

Se queda `Pending`: el PV sigue "recordando" a su antiguo PVC en `spec.claimRef`.

`kubectl get pv lab-08-pv-manual -o jsonpath='{.spec.claimRef.name} {.spec.claimRef.uid}'; echo`{{exec}}

El administrador decide qué hacer. Para reutilizarlo, quita esa referencia:

`kubectl patch pv lab-08-pv-manual --type=json -p '[{"op":"remove","path":"/spec/claimRef"}]'`{{exec}}

`sleep 5; kubectl get pvc claim-manual -n lab-08`{{exec}}

```text
persistentvolume/lab-08-pv-manual patched
NAME           STATUS   VOLUME             CAPACITY   ...
claim-manual   Bound    lab-08-pv-manual   200Mi      ...
```

Si todavía muestra `Pending`, espera unos segundos y repite el último comando.

**Qué observar**

- `Released` no es `Available`: un PV `Retain` no se reasigna solo a otro PVC.
- El `claimRef` guarda el `uid` del PVC antiguo; el PVC nuevo tiene otro `uid` y no encaja hasta que lo quitas.
- Los datos (`saludo.txt`) siguen en el nodo: el PVC nuevo los verá. Limpiarlos es tarea del administrador.

Pulsa **CHECK**.
