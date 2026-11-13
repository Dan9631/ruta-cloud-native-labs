Este Pod monta el PVC `datos` en `/data`. Fíjate en que pide el PVC por nombre, nunca el PV:

`cat /root/lab/03-pod-con-pvc.yaml`{{exec}}

`kubectl apply -f /root/lab/03-pod-con-pvc.yaml`{{exec}}

`kubectl wait --for=condition=Ready pod/app-pvc -n lab-08 --timeout=120s`{{exec}}

`kubectl get pvc -n lab-08`{{exec}}

`kubectl get pv`{{exec}}

`kubectl get pod app-pvc -n lab-08 -o wide`{{exec}}

```text
NAME    STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS
datos   Bound    pvc-c6c62a67-d6b3-40d6-bf8f-dac329d21bb7   100Mi      RWO            standard

NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM          STORAGECLASS
pvc-c6c62a67-d6b3-40d6-bf8f-dac329d21bb7   100Mi      RWO            Delete           Bound    lab-08/datos   standard

NAME      READY   STATUS    RESTARTS   AGE   IP            NODE
app-pvc   1/1     Running   0          27s   <ip>           node01
```

¿Dónde están los datos de verdad? Pregúntale al PV:

```
pv=$(kubectl get pvc datos -n lab-08 -o jsonpath='{.spec.volumeName}')
kubectl get pv $pv -o jsonpath='{.spec.hostPath.path}{.spec.local.path} -> nodo {.spec.nodeAffinity.required.nodeSelectorTerms[0].matchExpressions[0].values[0]}'; echo
```{{exec}}

```text
/opt/local-path-provisioner/pvc-c6c62a67-d6b3-40d6-bf8f-dac329d21bb7_lab-08_datos -> nodo node01
```

**Qué observar**

- El aprovisionador creó un PV llamado `pvc-<uid>` con la reclaim policy de la clase (`Delete`) y lo enlazó al PVC.
- Los PV no tienen namespace: son recursos de todo el clúster.
- El volumen es una carpeta del nodo, y el PV lleva `nodeAffinity` hacia ese nodo: cualquier Pod que use este PVC irá siempre a `node01`.
- La carpeta base depende de cómo esté configurado el aprovisionador: con la instalación de este escenario es `/opt/local-path-provisioner`; en el clúster kind del curso es `/var/local-path-provisioner`.

Pulsa **CHECK**.
