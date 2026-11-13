# Controladores, API y kubeconfig

Este escenario es la segunda parte del laboratorio del módulo 02 de **Ruta Cloud Native**. Trabajas en un clúster real de Kubernetes con dos nodos: `controlplane` y `node01`.

En unos 30 minutos vas a:

- seguir en los eventos qué componente hace cada cosa al crear un Deployment,
- ver un bucle de reconciliación reponer un Pod borrado,
- comprobar que kubectl solo hace peticiones REST al API server,
- explorar los grupos, versiones y tipos de la API,
- crear un contexto en una copia del kubeconfig sin tocar el original.

Todo se hace en el namespace `lab-02`, que se crea solo al arrancar.

Cómo usarlo:

- Haz clic en un comando para ejecutarlo en la terminal.
- Si un paso tiene **CHECK**, el escenario comprueba el estado del clúster antes de dejarte avanzar. Los pasos de solo observación se pasan con **NEXT**.
- La sesión dura como máximo una hora y el clúster se borra al terminar.

Espera a que la terminal muestre los dos nodos y pulsa **START**.
