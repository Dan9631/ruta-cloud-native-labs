Quita la carga dejando el generador en 0 réplicas:

`kubectl scale deployment generador-carga --replicas=0 -n lab-10`{{exec}}

Observa cómo baja. Esta vez el watch dura 4 minutos (puedes cortarlo con `Ctrl+C` en cuanto veas `REPLICAS` en 1):

`timeout 240 kubectl get hpa php-apache -n lab-10 -w`{{exec}}

Lo que verás, más o menos en este orden:

- durante 30-60 s el porcentaje sigue alto: la métrica todavía no refleja que ya no hay carga,
- después cae a valores como `cpu: 1%/50%`, pero las réplicas siguen en 4 un rato más,
- pasada la ventana de estabilización, `REPLICAS` baja hasta 1.

En total, unos 2 o 3 minutos desde que quitas la carga.

`kubectl get deploy -n lab-10`{{exec}}

**Qué observar**

- La métrica tarda en bajar porque metrics-server muestrea cada ~15 s y el HPA consulta cada 15 s.
- Las réplicas no bajan en cuanto baja la CPU: esperan la **ventana de estabilización** de bajada (`scaleDown.stabilizationWindowSeconds: 30`). El HPA usa la recomendación más alta de esa ventana para no bajar y volver a subir.
- Con el valor por defecto (300 s) habrías esperado más de 5 minutos.
- Subir es rápido y bajar es lento, a propósito: quedarse corto de réplicas es peor que tener alguna de sobra un rato.

Pulsa **CHECK** cuando `php-apache` haya vuelto a 1 réplica.
