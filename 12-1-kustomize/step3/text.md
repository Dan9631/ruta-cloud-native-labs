Simula que alguien escala prod «a mano», saltándose lo declarado:

`kubectl scale deploy prod-web -n lab-12 --replicas=5`{{exec}}

Compara lo declarado en el overlay con lo que hay en el clúster. `kubectl diff` necesita el programa `diff`, que ya viene en este sistema:

`kubectl diff -k /root/lab/kustomize/overlays/prod`{{exec}}

```text
-  replicas: 5
+  replicas: 3
```

Las líneas con `-` son el estado actual del clúster y las de `+`, lo que dice el overlay. Ahora reconcilia tú mismo:

`kubectl apply -k /root/lab/kustomize/overlays/prod`{{exec}}

`kubectl diff -k /root/lab/kustomize/overlays/prod && echo "Sin diferencias"`{{exec}}

```text
Sin diferencias
```

**Qué observar**

- `kubectl diff` termina sin salida (y con código 0) cuando el clúster coincide con lo declarado.
- Acabas de hacer a mano lo que un agente GitOps hace solo y de forma continua: **comparar** el estado declarado con el real y **corregir** la diferencia. Lo verás con Argo CD en el escenario 3 de este módulo.

Pulsa **CHECK**.
