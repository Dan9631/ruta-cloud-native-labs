En el namespace `lab-08`:

1. Crea una StorageClass **`lab-08-retener`** que use el aprovisionador `rancher.io/local-path`, conserve los datos al borrar el PVC (**Retain**) y espere al primer consumidor para crear el volumen.
2. Crea un PVC **`reto-datos`** de **64Mi**, **ReadWriteOnce**, de esa clase.
3. Crea un Pod **`reto-app`** (`busybox:1.37`) que monte ese PVC en **`/datos`** y escriba la palabra `kcna` en **`/datos/hola.txt`**. El Pod debe seguir en `Running` (que no termine al escribir).

**Pistas**

- Mira una StorageClass que ya existe como modelo: `kubectl get sc standard -o yaml`{{exec}}
- `kubectl explain storageclass.reclaimPolicy`{{exec}}
- `kubectl explain storageclass.volumeBindingMode`{{exec}}
- `kubectl explain pod.spec.volumes.persistentVolumeClaim`{{exec}}
- Escribe los manifiestos con un editor (`nano` o `vim`) y aplícalos con `kubectl apply -f`.
- Con `WaitForFirstConsumer`, el PVC estará `Pending` hasta que crees el Pod.

Cuando creas que está, pulsa **CHECK**.

**Si te atascas**

Hay una solución completa en `/root/solucion`. Inténtalo antes de mirarla:

`cat /root/solucion/pasos.txt`{{copy}}
