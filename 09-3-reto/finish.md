# Reto superado

Has dejado sano un namespace entero, y cada avería se encontraba en un sitio distinto:

- `api`: el contenedor llegaba a ejecutarse, así que la causa estaba en `logs --previous` (Exit Code 1, falta `DB_HOST`),
- `cache`: nunca se programó; el evento `FailedScheduling` del scheduler explicaba qué le pasaba a cada nodo,
- `worker`: `OOMKilled` con Exit Code 137, un `limits.memory` más bajo que lo que la aplicación necesita,
- `reporter`: `CreateContainerConfigError`, un ConfigMap referenciado con el nombre equivocado,
- `shop`: una liveness al puerto equivocado (la pista estaba en los eventos `Unhealthy` y `Killing`, no en los logs) y un Service cuyo selector no coincidía con ningún Pod.

La regla práctica que has aplicado: si el fallo ocurre **antes** de que arranque el contenedor, la respuesta está en `describe` y los eventos; si ocurre **después**, en los logs.

Con esto termina el laboratorio del módulo 09 de **Ruta Cloud Native**. Vuelve al curso para hacer el examen del módulo.
