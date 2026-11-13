# Primera parte terminada

Has visto que:

- cada nodo reparte IPs de Pods de su propio rango, y el CNI y kube-proxy corren en todos los nodos,
- un Service ClusterIP da una IP virtual y un nombre DNS estables a un grupo de Pods elegidos por label,
- CoreDNS resuelve `whoami` gracias al `search` del `/etc/resolv.conf` del Pod,
- los EndpointSlices siguen a los Pods `Ready` sin tocar el Service,
- un Service headless devuelve las IPs de los Pods y uno ExternalName es solo un CNAME,
- un NodePort abre el mismo puerto en todos los nodos, y kube-proxy reparte por conexión, no por petición.

Falta la entrada HTTP al clúster con un Ingress Controller y Gateway API. Ese es el siguiente escenario: **Módulo 06 (2 de 3) · Ingress y Gateway API con Traefik**.

El clúster de esta sesión se borra al cerrar, así que no hace falta limpiar nada.
