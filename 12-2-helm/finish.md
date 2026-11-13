# Segunda parte terminada

Has visto que:

- un chart es un conjunto de plantillas más unos values por defecto, y `helm template` lo renderiza sin tocar el clúster,
- `helm install` crea un **release** con su revisión 1 y `helm upgrade` crea revisiones nuevas,
- con `-f` o `--set` cambias los values sin editar el chart,
- Helm guarda cada revisión como un Secret en el namespace del release, sin ningún componente en el clúster,
- `helm rollback` no borra nada: crea una revisión nueva con el contenido de una anterior.

La siguiente parte junta las dos ideas del módulo: un agente que lee Git y reconcilia el clúster solo. **Módulo 12 (3 de 4) · GitOps con Argo CD**.

El clúster de esta sesión se borra al cerrar, así que no hace falta limpiar nada.
