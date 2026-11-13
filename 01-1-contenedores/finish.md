# Primera parte terminada

Has visto que:

- `podman run -d -p` arranca un contenedor en segundo plano y publica su puerto,
- los logs de un contenedor son su stdout/stderr,
- los namespaces le dan su propia vista de procesos, hostname y filesystem, pero el kernel es el de la máquina,
- los cgroups limitan su memoria y su CPU, igual que harán los `resources.limits` de Kubernetes,
- un contenedor parado conserva su capa escribible y al borrarlo la pierde.

El siguiente escenario es **Módulo 01 (2 de 4) · Construir imágenes y usar un registry**: construirás tu propia imagen, verás sus capas y la subirás a un registry.

La máquina de esta sesión se borra al cerrar, así que no hace falta limpiar nada.
