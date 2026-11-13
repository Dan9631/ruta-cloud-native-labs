# Primera parte terminada

Has visto que:

- una **base** de Kustomize guarda lo común y cada **overlay** declara solo las diferencias de su entorno,
- `kubectl kustomize` renderiza sin tocar el clúster y `kubectl apply -k` aplica el resultado,
- con `includeSelectors: true` la etiqueta del entorno llega a los selectores y los Services de dev y prod no se mezclan,
- `kubectl diff` compara lo declarado con lo que hay en el clúster: es el primer paso del bucle de reconciliación de GitOps.

La siguiente parte empaqueta una aplicación de otra forma, con plantillas y versiones: **Módulo 12 (2 de 4) · Helm**.

El clúster de esta sesión se borra al cerrar, así que no hace falta limpiar nada.
