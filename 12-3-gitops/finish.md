# Tercera parte terminada

Has visto que:

- Argo CD es un agente que vive **dentro** del clúster y tira de Git (modelo *pull*): nadie le empuja cambios,
- una **Application** une un origen (repo, rama, ruta) con un destino (clúster, namespace),
- con `selfHeal` cualquier cambio hecho a mano se deshace en segundos: el estado deseado está en Git,
- el cambio correcto es un commit; la columna `REVISION` de la Application es su SHA,
- con `prune` borrar un archivo del repo borra el recurso del clúster.

Queda el reto de Kustomize y Helm: **Módulo 12 (4 de 4) · Reto**.

El clúster de esta sesión se borra al cerrar, así que no hace falta desinstalar Argo CD.
