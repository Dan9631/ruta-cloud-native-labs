# Primera parte terminada

Has visto que:

- un Pod se puede crear con un comando y `--dry-run=client -o yaml` te da su manifiesto,
- los labels sirven para filtrar y las annotations no,
- los contenedores de un Pod comparten red y pueden compartir volúmenes,
- la `restartPolicy` decide si un contenedor que termina se reinicia,
- un ReplicaSet mantiene el número de Pods que coinciden con su selector.

En la práctica casi nunca se crea un ReplicaSet a mano: lo crea un **Deployment**. Ese es el siguiente escenario: **Módulo 03 (2 de 3) · Deployments, configuración y Jobs**.

El clúster de esta sesión se borra al cerrar, así que no hace falta limpiar nada.
