# kubectl debug, top y salud del clúster

Este escenario es la segunda parte del laboratorio del módulo 09 de **Ruta Cloud Native**. Trabajas en un clúster real de Kubernetes con dos nodos: `controlplane` y `node01`.

Al arrancar se despliega en el namespace `lab-09` el mismo «namespace en llamas» de la primera parte, con el caso 1 (`frontend`) ya arreglado. Los demás siguen rotos: los usarás como pacientes.

En unos 35 minutos vas a:

- inyectar un **contenedor efímero** en un Pod en ejecución,
- crear una **copia** de un Pod que no para de caerse para explorarlo,
- medir el consumo real con `kubectl top`,
- revisar los nodos, los static pods del control plane y el endpoint `/readyz`,
- leer el kubelet con `systemctl` y `journalctl`, y los contenedores del nodo con `crictl`.

El arranque instala también **metrics-server** (lo necesita `kubectl top`), deja `controlplane` con su taint de control-plane (las aplicaciones van a `node01`) y pone a `node01` los labels `disktype=ssd` y `zone=zona-a`, como en el clúster del curso. Tarda uno o dos minutos.

Cómo usarlo:

- Haz clic en un comando para ejecutarlo en la terminal.
- Al final de cada paso pulsa **CHECK**: el escenario comprueba el estado del clúster antes de dejarte avanzar.
- La sesión dura como máximo una hora y el clúster se borra al terminar.

Espera a que la terminal muestre los Pods de `lab-09` y pulsa **START**.
