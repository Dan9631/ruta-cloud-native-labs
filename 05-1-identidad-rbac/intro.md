# Identidad, RBAC y ServiceAccounts

Este escenario es la primera parte del laboratorio del módulo 05 de **Ruta Cloud Native**. Trabajas en un clúster real de Kubernetes con dos nodos: `controlplane` y `node01`. La terminal está en `controlplane`, así que puedes mirar directamente los certificados del clúster.

En unos 35 minutos vas a:

- ver con qué identidad hablas con el API server y de dónde sale,
- recorrer la CA del clúster y los API groups,
- dar permisos mínimos a una ServiceAccount con Role y RoleBinding,
- darle acceso a un recurso de todo el clúster con ClusterRole y ClusterRoleBinding,
- usar el token de esa ServiceAccount desde dentro de un Pod.

Todo se hace en el namespace `lab-05`, que se crea solo al arrancar. Los manifiestos están en `/root/lab`. Los objetos que no pertenecen a ningún namespace (ClusterRole, ClusterRoleBinding) llevan el prefijo `lab-05-`.

Cómo usarlo:

- Haz clic en un comando para ejecutarlo en la terminal.
- Al final de cada paso pulsa **CHECK**: el escenario comprueba el estado antes de dejarte avanzar.
- La sesión dura como máximo una hora y el clúster se borra al terminar.

Espera a que la terminal muestre los dos nodos y pulsa **START**.
