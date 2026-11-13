# Primera parte terminada

Has visto que:

- el HPA saca la CPU de la Metrics API, que sirve metrics-server: sin él, `TARGETS` se queda en `<unknown>`,
- el porcentaje se calcula sobre los `requests` de CPU,
- las réplicas deseadas salen de `ceil(réplicas actuales × valor actual / valor objetivo)`, dentro de `minReplicas` y `maxReplicas`,
- el bloque `behavior` controla la velocidad: aquí, como mucho duplicar cada 15 s al subir y una ventana de 30 s al bajar,
- subir es rápido y bajar es lento a propósito, y por defecto la ventana de bajada es de 300 s,
- `kubectl describe hpa` explica cada decisión con sus condiciones y eventos.

Queda el reto: **Módulo 10 (2 de 2) · Reto**. Allí no hay comandos para copiar: creas tú un Deployment y su HPA, con `behavior` incluido, y el escenario lo comprueba.

El clúster de esta sesión se borra al cerrar, así que no hace falta limpiar nada.
