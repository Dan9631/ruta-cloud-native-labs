# Primera parte terminada

Has visto que:

- el scheduler filtra los nodos que no sirven y puntúa los que quedan; con `nodeName` te lo saltas,
- los selectors de igualdad, de conjunto y de existencia filtran Pods y nodos,
- `nodeSelector` obliga y, si ningún nodo encaja, el Pod queda `Pending` con un evento `FailedScheduling` que explica el filtrado,
- node affinity distingue entre lo obligatorio (*required*) y lo preferido (*preferred*),
- pod anti-affinity reparte réplicas por nodo y deja `Pending` las que no caben,
- un taint repele, una toleration permite entrar y la afinidad obliga: juntos hacen un nodo dedicado.

Recuerda la diferencia con el lab local: aquí `controlplane` aceptaba Pods porque se le quitó el taint al empezar.

Sigue con **Módulo 04 (2 de 3) · Recursos, DaemonSets y prioridad**.

El clúster de esta sesión se borra al cerrar, así que no hace falta limpiar nada.
