# Segunda parte terminada

Has visto que:

- un `Containerfile` es la receta de una imagen y el `.` del build es su contexto,
- solo las instrucciones que cambian archivos (`COPY`, `RUN`, `ADD`) crean capas; `LABEL`, `ENV` y `EXPOSE` son metadatos,
- las capas de la imagen base se reutilizan,
- el nombre de una imagen dice a qué registry pertenece, y `tag`, `push` y `pull` la mueven entre almacenes,
- un build multi-stage deja fuera de la imagen final las herramientas de construcción.

El siguiente escenario es **Módulo 01 (3 de 4) · Tu imagen en Kubernetes**: llevarás tu imagen a un nodo y la ejecutarás como Pod.

La máquina de esta sesión se borra al cerrar, así que no hace falta limpiar nada.
