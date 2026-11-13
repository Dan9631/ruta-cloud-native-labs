# Reto superado

Has publicado sin guía una versión nueva de tu imagen:

- cambiaste el contenido y los metadatos OCI y construiste `localhost/kcna-web:2.0`,
- la llevaste del almacén de Podman al containerd del nodo,
- la ejecutaste como Pod con sus labels, sin que el kubelet tuviera que descargar nada.

Es el ciclo de la infraestructura inmutable: no se cambia un contenedor en marcha, se construye una imagen nueva y se despliega.

Con esto termina el laboratorio del módulo 01 de **Ruta Cloud Native**. Vuelve al curso para hacer el examen del módulo.
