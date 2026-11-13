Lee el manifiesto. Tiene tres objetos: una StorageClass `lab-08-manual` **sin aprovisionador** y con binding `Immediate`; un PV `lab-08-pv-manual` de 200Mi que apunta a la carpeta `/tmp/lab-08-pv` del nodo `node01`, con `Retain`; y un PVC `claim-manual` que pide 100Mi.

`cat /root/lab/04-pv-estatico.yaml`{{exec}}

`kubectl apply -f /root/lab/04-pv-estatico.yaml`{{exec}}

`kubectl get sc lab-08-manual`{{exec}}

`kubectl get pv lab-08-pv-manual`{{exec}}

`kubectl get pvc claim-manual -n lab-08`{{exec}}

```text
NAME            PROVISIONER                    RECLAIMPOLICY   VOLUMEBINDINGMODE   ALLOWVOLUMEEXPANSION
lab-08-manual   kubernetes.io/no-provisioner   Retain          Immediate           false

NAME               CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                 STORAGECLASS
lab-08-pv-manual   200Mi      RWO            Retain           Bound    lab-08/claim-manual   lab-08-manual

NAME           STATUS   VOLUME             CAPACITY   ACCESS MODES   STORAGECLASS
claim-manual   Bound    lab-08-pv-manual   200Mi      RWO            lab-08-manual
```

Ahora un Pod que usa ese PVC y escribe un saludo:

`kubectl apply -f /root/lab/05-pod-pv-manual.yaml`{{exec}}

`kubectl wait --for=condition=Ready pod/app-manual -n lab-08 --timeout=120s`{{exec}}

`kubectl get pod app-manual -n lab-08 -o wide`{{exec}}

El archivo está en una carpeta de `node01`. Míralo por SSH:

`ssh node01 cat /tmp/lab-08-pv/saludo.txt`{{exec}}

```text
hola desde app-manual
```

**Qué observar**

- Con `Immediate` el PVC se enlaza **sin Pod**.
- Pidió 100Mi pero recibe el PV entero de **200Mi**: el binding es 1:1.
- El Pod fue a `node01` por la `nodeAffinity` del PV.
- El archivo está literalmente en una carpeta del nodo. Así de expuesto está el nodo con hostPath.

Pulsa **CHECK**.
