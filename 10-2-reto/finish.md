# Reto superado

Has creado sin guía un autoscalado completo:

- un Deployment con `requests` de CPU, la base sobre la que el HPA calcula el porcentaje,
- un HPA `autoscaling/v2` con su rango de réplicas y su objetivo de CPU,
- un bloque `behavior` con una ventana de bajada de 60 s, algo que `kubectl autoscale` no rellena,
- un HPA que ya lee métricas de metrics-server (`ScalingActive True`).

Con esto termina el laboratorio del módulo 10 de **Ruta Cloud Native**. Vuelve al curso para hacer el examen del módulo.
