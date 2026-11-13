# Segunda parte terminada

Has visto que:

- una StorageClass con `kubernetes.io/no-provisioner` solo agrupa PVs creados a mano,
- con `Immediate` el PVC se enlaza sin Pod, y recibe el PV entero aunque pida menos,
- `hostPath` deja los datos en una carpeta de un nodo concreto: útil para aprender, peligroso en producción,
- con `Retain` el PV queda `Released` con sus datos y no se reutiliza hasta que el administrador quita el `claimRef`,
- un StatefulSet da a cada réplica su propio PVC, que conserva aunque el Pod se recree o se reduzcan réplicas,
- un volumen projected junta ConfigMap, Secret y downwardAPI en un directorio de solo lectura.

Queda el reto: **Módulo 08 (3 de 3) · Reto**. Allí no hay comandos para copiar: creas tu propia StorageClass y el escenario la comprueba.

El clúster de esta sesión se borra al cerrar, así que no hace falta limpiar nada.
