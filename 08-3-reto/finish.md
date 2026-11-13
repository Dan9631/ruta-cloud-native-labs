# Reto superado

Has construido sin guía:

- una StorageClass propia que reutiliza un aprovisionador existente pero con `Retain` y `WaitForFirstConsumer`,
- un PVC que espera a su primer consumidor y recibe un PV creado al vuelo,
- un PV que hereda de la clase la reclaim policy `Retain`: si borras el PVC, quedará `Released` con los datos,
- un Pod que monta el PVC y escribe en él.

Con esto termina el laboratorio del módulo 08 de **Ruta Cloud Native**. Vuelve al curso para hacer el examen del módulo.
