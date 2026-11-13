# Segunda parte terminada

Has visto que:

- al crear un Deployment actúan, por turnos, el controlador de Deployment, el de ReplicaSet, el scheduler y el kubelet, y los eventos lo cuentan,
- los controladores reconcilian sin fin el estado real (`status`) con el deseado (`spec`),
- kubectl es un cliente REST: el grupo core va a `/api/v1` y el resto a `/apis/GRUPO/VERSION`,
- `api-resources`, `api-versions` y `explain` describen la API del propio clúster,
- un contexto del kubeconfig combina cluster, usuario y namespace, y se puede practicar en una copia.

Queda el reto: **Módulo 02 (3 de 3) · Reto**, donde documentas la arquitectura del clúster con lo que has descubierto.

El clúster de esta sesión se borra al cerrar, así que no hace falta limpiar nada.
