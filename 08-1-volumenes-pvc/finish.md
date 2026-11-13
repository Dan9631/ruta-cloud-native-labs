# Primera parte terminada

Has visto que:

- un `emptyDir` se comparte entre los contenedores de un Pod y muere con el Pod,
- con `WaitForFirstConsumer` el PVC espera en `Pending` hasta que un Pod lo usa,
- el aprovisionador crea el PV al vuelo y lo enlaza 1:1 con el PVC, con la reclaim policy de la clase,
- los datos de un PVC sobreviven al Pod,
- ampliar un PVC exige una StorageClass con `allowVolumeExpansion: true`.

El siguiente escenario es **Módulo 08 (2 de 3) · PV estático, StatefulSets y volúmenes projected**: crearás un PV a mano, verás qué hace `Retain` y darás un disco propio a cada réplica de un StatefulSet.

El clúster de esta sesión se borra al cerrar, así que no hace falta limpiar nada.
