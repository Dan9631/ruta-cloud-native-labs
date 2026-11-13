En el namespace `lab-10`, crea:

1. Un Deployment llamado `web` con la imagen `nginx:1.27-alpine`, **2 réplicas** y `requests` de `cpu: 50m` y `memory: 16Mi`.
2. Un HPA llamado `web` (`autoscaling/v2`) que:
   - escale el Deployment `web` entre **2 y 6** réplicas,
   - tenga como objetivo un **60%** de utilización media de CPU,
   - tenga una **ventana de estabilización de bajada de 60 segundos**.
3. Espera a que el HPA lea métricas: la columna `TARGETS` de `kubectl get hpa` debe mostrar un porcentaje, no `<unknown>`.

**Pistas**

- `kubectl autoscale` crea el HPA rápido, pero el bloque `behavior` necesita YAML. Con el Deployment ya creado, genera un esqueleto con `kubectl autoscale deployment web -n lab-10 --min=2 --max=6 --cpu=60% --dry-run=client -o yaml > web-hpa.yaml` y complétalo con un editor (`nano` o `vim`).
- El Deployment también lo puedes empezar con `kubectl create deployment ... --dry-run=client -o yaml`.
- `kubectl explain hpa.spec.behavior.scaleDown --api-version=autoscaling/v2`{{exec}}
- `kubectl explain deployment.spec.template.spec.containers.resources`{{exec}}
- Sin `requests.cpu`, el HPA no puede calcular el porcentaje.

Cuando creas que está, pulsa **CHECK**. Si solo falla el último requisito, espera un minuto: el HPA tarda en recibir las primeras métricas.

**Si te atascas**

Hay una solución completa en `/root/solucion`. Inténtalo antes de mirarla:

`cat /root/solucion/pasos.txt`{{copy}}
