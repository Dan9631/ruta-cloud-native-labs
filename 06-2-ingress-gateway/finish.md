# Segunda parte terminada

Has visto que:

- Kubernetes no trae Ingress Controller: el objeto Ingress lo atiende Traefik a través de la IngressClass `traefik`,
- Traefik reparte por petición, porque es un proxy L7 que habla directamente con los Pods,
- con Gateway API, el Gateway lo gestiona el operador en su namespace y tú solo creas la HTTPRoute en el tuyo,
- `kubectl port-forward` es un túnel de depuración a un solo Pod, no una forma de publicar.

Falta el reto: publicar una aplicación nueva de varias formas a la vez, sin guía. Es el siguiente escenario: **Módulo 06 (3 de 3) · Reto**.

El clúster de esta sesión se borra al cerrar, así que no hace falta limpiar nada.
