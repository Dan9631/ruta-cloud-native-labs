En el namespace `lab-03`, construye esta aplicación:

1. Un ConfigMap `web-config` con una clave `index.html`. El contenido HTML es a tu gusto.
2. Un Secret `web-secret` con una clave `api-token`.
3. Un Deployment `web` con 3 réplicas y el label `app=web`, que:
   - use la estrategia RollingUpdate con `maxSurge: 1` y `maxUnavailable: 0`,
   - monte `web-config` en `/usr/share/nginx/html`, para que nginx sirva tu `index.html`,
   - exponga el Secret como variable de entorno `API_TOKEN`, con `secretKeyRef`,
   - se cree primero con `nginx:1.27-alpine` y después se **actualice** a `nginx:1.28-alpine`. El historial debe tener al menos 2 revisiones.

**Pistas**

- Genera la base con `kubectl create deployment ... --dry-run=client -o yaml > web.yaml` y complétala con un editor (`nano` o `vim`).
- `kubectl explain deployment.spec.strategy.rollingUpdate`{{exec}}
- `kubectl explain pod.spec.volumes.configMap`{{exec}}
- `kubectl explain pod.spec.containers.env.valueFrom.secretKeyRef`{{exec}}

Cuando creas que está, pulsa **CHECK**.

**Si te atascas**

Hay una solución completa en `/root/solucion`. Inténtalo antes de mirarla:

`cat /root/solucion/pasos.txt`{{copy}}
