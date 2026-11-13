# Sidecars y canary con Gateway API

Este escenario es el laboratorio guiado del módulo 07 de **Ruta Cloud Native**. El clúster empieza limpio, con dos nodos (`controlplane` y `node01`).

Es un laboratorio **ligero**: no se instala ningún service mesh, porque consumen mucha memoria. Practicarás las dos piezas que están debajo de cualquier mesh:

- el patrón **sidecar**, con un native sidecar container que lee los logs de nginx,
- la **división de tráfico por pesos**, con un despliegue canary de `whoami` v1 y v2 detrás de una HTTPRoute de Gateway API.

Al arrancar se crean el namespace `lab-07`, los CRD de Gateway API y **Traefik**, que hace de controlador de Gateway: crea el Gateway `traefik-gateway` en el namespace `traefik` y escucha en el puerto **30080** de los nodos (un NodePort). Tarda entre uno y tres minutos. Los manifiestos están en `/root/lab`.

Haz clic en un comando para ejecutarlo y pulsa **CHECK** al final de cada paso. Calcula unos 40 minutos; la sesión dura como máximo una hora.

Espera a que la terminal diga que Traefik responde y pulsa **START**.
