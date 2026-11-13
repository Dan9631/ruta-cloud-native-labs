# Contenedores con Podman

Este escenario es la primera parte del laboratorio del módulo 01 de **Ruta Cloud Native**. Trabajas en una máquina Ubuntu con **Podman**. Aquí todavía no hay Kubernetes: primero hay que entender qué es un contenedor.

En unos 25 minutos vas a:

- arrancar un contenedor de nginx y publicar su puerto,
- leer sus logs y ver sus procesos desde fuera,
- comprobar qué cambia dentro del contenedor gracias a los namespaces (y qué no: el kernel),
- limitar memoria y CPU con cgroups,
- parar y borrar contenedores.

Cómo usarlo:

- Haz clic en un comando para ejecutarlo en la terminal.
- Al final de cada paso pulsa **CHECK**: el escenario comprueba el estado de los contenedores antes de dejarte avanzar.
- La sesión dura como máximo una hora y la máquina se borra al terminar.

Casi todos los comandos `podman ...` funcionan igual con `docker ...`.

Espera a que la terminal diga que está lista y pulsa **START**.
