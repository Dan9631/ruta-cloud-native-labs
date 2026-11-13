El HPA necesita la **Metrics API**, que sirve metrics-server. Si `kubectl top` responde, el HPA podrá leer métricas:

`kubectl top nodes`{{exec}}

```text
NAME           CPU(cores)   CPU(%)   MEMORY(bytes)   MEMORY(%)
controlplane   ...
node01         ...
```

Si dice que las métricas aún no están disponibles, espera medio minuto y repítelo.

Lee los dos manifiestos. Fíjate en `requests.cpu: 100m` de la app y, en el HPA, en el objetivo del 50%, el rango de 1 a 4 réplicas y el bloque `behavior`:

`cat /root/lab/01-php-apache.yaml`{{exec}}

`cat /root/lab/02-hpa.yaml`{{exec}}

Aplícalos y espera a que la app arranque (la primera vez descarga la imagen, puede tardar un minuto):

`kubectl apply -f /root/lab/01-php-apache.yaml -f /root/lab/02-hpa.yaml`{{exec}}

`kubectl rollout status deployment/php-apache -n lab-10 --timeout=180s`{{exec}}

`kubectl get hpa -n lab-10`{{exec}}

```text
NAME         REFERENCE               TARGETS              MINPODS   MAXPODS   REPLICAS   AGE
php-apache   Deployment/php-apache   cpu: <unknown>/50%   1         4         1          11s
```

Repite el último comando hasta que `TARGETS` muestre un porcentaje, por ejemplo `cpu: 1%/50%`. Suele tardar entre 30 s y 2 minutos.

**Qué observar**

- Al principio el objetivo sale `<unknown>`: metrics-server aún no tiene muestras del Pod nuevo.
- El porcentaje se calcula **sobre los `requests`**: sin `requests.cpu`, el HPA se quedaría en `<unknown>` y no escalaría.
- En este escenario el máximo es 4 réplicas y el `limit` de CPU de cada Pod es 200m (en el curso son 5 y 300m): el clúster es más pequeño.

Pulsa **CHECK** cuando `TARGETS` muestre un porcentaje.
