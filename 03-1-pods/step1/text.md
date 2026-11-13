Con `--dry-run=client -o yaml` kubectl no crea nada: solo imprime el manifiesto que enviaría.

`kubectl run nginx --image=nginx:1.27-alpine -n lab-03 --labels='app=nginx,tier=web' --dry-run=client -o yaml`{{exec}}

Ahora créalo de verdad y míralo:

`kubectl run nginx --image=nginx:1.27-alpine -n lab-03 --labels='app=nginx,tier=web'`{{exec}}

`kubectl get pod nginx -n lab-03 -o wide --show-labels`{{exec}}

Repite el último comando hasta que el Pod esté `Running`. Luego consulta tres campos concretos:

`kubectl get pod nginx -n lab-03 -o jsonpath='{.status.phase} {.status.qosClass} {.spec.restartPolicy}'; echo`{{exec}}

```text
Running BestEffort Always
```

**Qué observar**

- La salida del `--dry-run` es un manifiesto listo para guardar y editar.
- Sin `resources`, el Pod es de clase QoS **BestEffort**: es lo primero que se expulsa si al nodo le falta memoria.
- La `restartPolicy` por defecto es `Always`.

Pulsa **CHECK** cuando el Pod esté `Running`.
