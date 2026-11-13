La carga sigue en marcha. Pregunta al HPA por qué ha hecho lo que ha hecho:

`kubectl describe hpa php-apache -n lab-10`{{exec}}

Las partes que interesan (tus porcentajes serán otros):

```text
Metrics:                                               ( current / target )
  resource cpu on pods  (as a percentage of request):  63% (63m) / 50%
Min replicas:                                          1
Max replicas:                                          4
Behavior:
  Scale Up:
    Stabilization Window: 0 seconds
    Policies:
      - Type: Percent  Value: 100  Period: 15 seconds
  Scale Down:
    Stabilization Window: 30 seconds
...
Conditions:
  Type            Status  Reason            Message
  AbleToScale     True    ReadyForNewScale  recommended size matches current size
  ScalingActive   True    ValidMetricFound  the HPA was able to successfully calculate a replica count from cpu ...
  ScalingLimited  True    TooManyReplicas   the desired replica count is more than the maximum replica count
Events:
  Warning  FailedGetResourceMetric  ...  unable to get metrics for resource cpu: no metrics returned from resource metrics API
  Normal   SuccessfulRescale        ...  New size: 2; reason: cpu resource utilization (percentage of request) above target
  Normal   SuccessfulRescale        ...  New size: 4; reason: cpu resource utilization (percentage of request) above target
```

Compara con lo que reporta metrics-server, la misma fuente que usa el HPA:

`kubectl top pods -n lab-10`{{exec}}

Y la Metrics API en crudo (es JSON; aquí solo se muestra el principio):

`kubectl get --raw /apis/metrics.k8s.io/v1beta1/namespaces/lab-10/pods | head -c 600; echo`{{exec}}

**Qué observar**

- `ScalingActive True` = el HPA lee métricas.
- `ScalingLimited True` con `TooManyReplicas` aparece si el HPA quiere más réplicas de las permitidas. Si con 4 Pods el promedio ya está cerca del 50%, la verás en `False`.
- Los `SuccessfulRescale` muestran la escalera 2 → 4.
- Los avisos `FailedGetResourceMetric` del principio son normales: corresponden al `<unknown>` de los primeros segundos.
- El HPA trabaja con el **promedio**. En `kubectl top pods` verás que el reparto entre Pods no es perfecto: el Service balancea conexión a conexión.

Este paso no tiene comprobación. Pulsa **NEXT**.
