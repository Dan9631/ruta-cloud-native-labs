# Primera parte terminada

Has visto que:

- las apps escriben sus logs en stdout y stderr, el nodo los guarda y `kubectl logs` los lee; sin un agente de logs, se pierden con el Pod,
- `kubectl top` da el consumo actual gracias a metrics-server, sin historial,
- un chart tiene su propia versión, distinta de la de la aplicación, y `helm template` te dice qué imágenes usará,
- Prometheus descubre solo sus targets (nodos, cAdvisor, Services y Pods anotados) con el service discovery de Kubernetes,
- node-exporter es un DaemonSet con la red del nodo, y las métricas son texto plano con su tipo declarado.

Para limpiar en un clúster propio usarías `helm uninstall prometheus -n lab-11`, que borra también los recursos que el chart creó fuera del namespace. Aquí no hace falta: el clúster de esta sesión se borra al cerrar.

El siguiente escenario empieza con Prometheus ya instalado y se dedica a las consultas: **Módulo 11 (2 de 3) · Consultas PromQL**.
