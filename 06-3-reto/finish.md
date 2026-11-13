# Reto superado

Has publicado sin guía una aplicación con las piezas del módulo:

- un Service ClusterIP cuyo puerto (8080) es distinto del de los Pods (80), gracias a `targetPort`,
- un Service headless que devuelve por DNS las IPs de los Pods,
- un Ingress que atiende Traefik por su IngressClass,
- una HTTPRoute en tu namespace colgada de un Gateway de otro namespace.

Con esto termina el laboratorio del módulo 06 de **Ruta Cloud Native**. Vuelve al curso para hacer el examen del módulo.
