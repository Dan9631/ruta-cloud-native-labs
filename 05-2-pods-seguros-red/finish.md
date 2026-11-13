# Segunda parte terminada

Has visto que:

- sin `securityContext` un contenedor corre como root, con escritura y con capabilities; endurecido corre sin root, con raíz de solo lectura y sin capabilities,
- Pod Security Admission se activa con labels en el namespace, no toca los Pods que ya existen y rechaza los nuevos con la lista de lo que falta,
- con un Deployment, el rechazo aparece en los eventos del ReplicaSet,
- una NetworkPolicy de default deny más otra que abre por labels deja pasar solo el tráfico que quieres, siempre que el plugin de red las aplique,
- un Secret en base64 no está cifrado: lo protegen RBAC y el cifrado en reposo de etcd.

Queda el reto: **Módulo 05 (3 de 3) · Reto**. Allí no hay comandos para copiar: das permisos mínimos, creas un Pod que cumple `restricted` y escribes una NetworkPolicy, y el escenario lo comprueba.

El clúster de esta sesión se borra al cerrar, así que no hace falta limpiar nada.
