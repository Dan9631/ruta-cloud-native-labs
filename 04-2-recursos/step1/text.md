El manifiesto crea tres Pods que solo se diferencian en su bloque `resources`. Léelo antes de aplicarlo:

`cat /root/lab/10-qos.yaml`{{exec}}

`kubectl apply -f /root/lab/10-qos.yaml`{{exec}}

`kubectl get pod qos-guaranteed -n lab-04 -o jsonpath='{.status.qosClass}'; echo`{{exec}}

`kubectl get pods -n lab-04 -o custom-columns='POD:.metadata.name,QOS:.status.qosClass,NODO:.spec.nodeName'`{{exec}}

```text
Guaranteed
POD              QOS          NODO
qos-besteffort   BestEffort   node01
qos-burstable    Burstable    node01
qos-guaranteed   Guaranteed   node01
```

La columna `NODO` puede variar: estos Pods no tienen reglas de scheduling.

Mira cuánto tiene reservado cada nodo (la suma de requests) frente a lo que se consume de verdad:

`for n in controlplane node01; do echo "== $n"; kubectl describe node $n | grep -A 6 'Allocated resources'; done`{{exec}}

```text
== controlplane
Allocated resources:
  (Total limits may be over 100 percent, i.e., overcommitted.)
  Resource           Requests     Limits
  --------           --------     ------
  cpu                ...          ...
  memory             ...          ...
== node01
...
```

`kubectl top pod -n lab-04`{{exec}}

```text
NAME             CPU(cores)   MEMORY(bytes)
qos-besteffort   0m           0Mi
qos-burstable    0m           0Mi
qos-guaranteed   0m           0Mi
```

Si `kubectl top` responde `Metrics API not available`, metrics-server aún está arrancando: espera un minuto y repite. Es opcional.

**Qué observar**

- La QoS class no se declara, **se deduce** de requests y limits. Compara cada Pod con su bloque `resources`.
- `Allocated resources` suma los requests de todos los Pods del nodo: es lo que usa el scheduler para decidir si un Pod cabe. En `controlplane` ya hay bastante reservado por los componentes del plano de control.
- `kubectl top` muestra el consumo real, que no tiene nada que ver con lo reservado: un `sleep` casi no gasta. Tus números variarán.

Pulsa **CHECK**.
