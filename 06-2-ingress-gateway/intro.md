# Ingress y Gateway API con Traefik

Este escenario es la segunda parte del laboratorio del módulo 06 de **Ruta Cloud Native**. Trabajas en un clúster real de Kubernetes con dos nodos: `controlplane` y `node01`.

Kubernetes no trae ningún Ingress Controller. Al arrancar, el escenario instala lo mismo que el clúster local del curso:

- los CRDs de **Gateway API** v1.6.3,
- **Traefik** (chart 42.1.3) como Ingress Controller y como implementación de Gateway API, con la IngressClass `traefik` por defecto y un Gateway compartido `traefik-gateway` en el namespace `traefik`.

En el curso, Traefik escucha en el puerto 80 del nodo y lo ves en `http://localhost:8080`. Aquí no hay balanceador, así que Traefik se publica con un Service **NodePort** en el puerto **30800** de los nodos.

También deja preparado, en el namespace `lab-06`, lo que creaste en la primera parte: el Deployment `whoami` con 3 réplicas y su Service ClusterIP `whoami`.

En unos 25 minutos vas a:

- publicar whoami por path con un **Ingress**,
- publicarlo con una **HTTPRoute** colgada del Gateway,
- abrir un túnel de depuración con `kubectl port-forward`.

Los manifiestos están en `/root/lab`. Al final de cada paso pulsa **CHECK**. La sesión dura como máximo una hora.

La preparación tarda unos minutos. Espera a que la terminal muestre los dos nodos y pulsa **START**.
