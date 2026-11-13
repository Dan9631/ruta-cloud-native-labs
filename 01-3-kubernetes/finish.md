# Tercera parte terminada

Has visto que:

- Podman y containerd tienen almacenes de imágenes separados, aunque estén en la misma máquina,
- un clúster local "carga" una imagen exportándola e importándola en el containerd del nodo; en un clúster real se sube a un registry,
- con tag fijo e `imagePullPolicy: IfNotPresent`, el kubelet usa la imagen que ya está en el nodo,
- `crictl` muestra el contenedor que containerd ejecuta debajo del Pod,
- si la imagen no está en el nodo y no se puede descargar, el Pod se queda en `ErrImagePull` y luego en `ImagePullBackOff`.

Solo queda el **Módulo 01 (4 de 4) · Reto**: publicar la versión 2.0 de tu imagen y ejecutarla en el clúster sin guía.

El clúster de esta sesión se borra al cerrar, así que no hace falta limpiar nada.
