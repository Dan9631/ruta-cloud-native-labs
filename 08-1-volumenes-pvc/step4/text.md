Escribe un pedido en el volumen:

`kubectl exec app-pvc -n lab-08 -- sh -c 'echo pedido 1001: 3 cafes > /data/pedidos.txt; date >> /data/pedidos.txt; cat /data/pedidos.txt'`{{exec}}

Borra el Pod. El PVC sigue ahí:

`kubectl delete pod app-pvc -n lab-08`{{exec}}

`kubectl get pvc datos -n lab-08`{{exec}}

```text
NAME    STATUS   VOLUME                                     CAPACITY   ...
datos   Bound    pvc-c6c62a67-d6b3-40d6-bf8f-dac329d21bb7   100Mi      ...
```

Los datos están en la carpeta del nodo `node01`. Entra por SSH y míralos sin pasar por ningún Pod:

```
pv=$(kubectl get pvc datos -n lab-08 -o jsonpath='{.spec.volumeName}')
ruta=$(kubectl get pv $pv -o jsonpath='{.spec.hostPath.path}{.spec.local.path}')
ssh node01 "ls -l $ruta; cat $ruta/pedidos.txt"
```{{exec}}

Crea un Pod nuevo con el mismo manifiesto y lee el archivo:

`kubectl apply -f /root/lab/03-pod-con-pvc.yaml`{{exec}}

`kubectl wait --for=condition=Ready pod/app-pvc -n lab-08 --timeout=120s`{{exec}}

`kubectl exec app-pvc -n lab-08 -- cat /data/pedidos.txt`{{exec}}

```text
pedido 1001: 3 cafes
Fri Oct 23 16:57:50 UTC 2026
```

**Qué observar**

- El PVC sigue `Bound` sin ningún Pod, y el Pod nuevo encuentra los datos. Esa es la diferencia con emptyDir.
- Con local-path, el volumen es literalmente una carpeta del nodo: por eso puedes leerla por SSH. En un clúster real sería un disco de la nube, un export NFS, etc.

Pulsa **CHECK**.
