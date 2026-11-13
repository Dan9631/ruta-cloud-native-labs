Lanza el generador de carga: un Pod de busybox que pide la página de `php-apache` en bucle.

`cat /root/lab/03-generador-carga.yaml`{{exec}}

`kubectl apply -f /root/lab/03-generador-carga.yaml`{{exec}}

Ahora observa el HPA en vivo. `-w` (*watch*) imprime una línea nueva cada vez que cambia; `timeout 180` lo corta solo a los 3 minutos (puedes pararlo antes con `Ctrl+C`):

`timeout 180 kubectl get hpa php-apache -n lab-10 -w`{{exec}}

Lo que verás, más o menos en este orden (tus cifras serán otras):

- unos 30-60 s después de empezar la carga, `TARGETS` sube muy por encima del 50%, por ejemplo `cpu: 190%/50%`,
- `REPLICAS` pasa de 1 a 2, y poco después a 4,
- con 4 réplicas la carga se reparte y el porcentaje baja, aunque puede seguir por encima del 50%.

Cuando termine el watch, mira dónde han caído los Pods:

`kubectl get pods -n lab-10 -o wide`{{exec}}

**Qué observar**

- Con un Pod al ~200% de sus `requests`, la fórmula pide `ceil(1 × 200 / 50) = 4` réplicas.
- La política de `scaleUp` (como mucho duplicar cada 15 s) obliga a pasar por 2 antes de llegar a 4.
- Si el promedio sigue por encima del 50% con 4 réplicas, el HPA querría más, pero está en `maxReplicas`.
- El `limit` de 200m deja que un Pod use hasta el doble de lo que pide. Los `requests` son la base del porcentaje; los `limits`, el techo.
- La columna `NODE` muestra en qué nodo está cada Pod. Si `controlplane` tiene el taint de plano de control, todos irán a `node01`.

Pulsa **CHECK** cuando `REPLICAS` sea 2 o más.
