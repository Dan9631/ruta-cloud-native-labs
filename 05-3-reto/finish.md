# Reto superado

Has aplicado sin guía las piezas de seguridad del módulo:

- una ServiceAccount con permisos mínimos: gestiona Deployments solo en su namespace y no lee Secrets,
- un ClusterRole y un ClusterRoleBinding para un recurso de todo el clúster, los nodos, solo en lectura,
- un Pod que cumple el perfil `restricted`: sin root, sin capabilities, sin escalada de privilegios, con seccomp y con la raíz de solo lectura,
- una NetworkPolicy que solo deja entrar a la base de datos el tráfico de la API, en su puerto.

Con esto termina el laboratorio del módulo 05 de **Ruta Cloud Native**. Vuelve al curso para hacer el examen del módulo.
