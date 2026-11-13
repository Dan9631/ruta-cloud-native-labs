# Componentes del clúster

Este escenario es la primera parte del laboratorio del módulo 02 de **Ruta Cloud Native**. Trabajas en un clúster real de Kubernetes montado con **kubeadm** sobre dos máquinas: `controlplane` (el plano de control) y `node01` (un nodo de trabajo).

La terminal se abre en `controlplane`. Puedes mirar sus archivos y servicios directamente y saltar a `node01` con `ssh node01`.

En unos 30 minutos vas a:

- ver los nodos, sus versiones y su runtime,
- distinguir los tres tipos de componentes del sistema: static pods, DaemonSets y Deployments,
- crear tu propio static pod y comprobar que el kubelet lo gestiona sin pasar por el scheduler,
- leer la configuración del API server y de etcd,
- ver el kubelet y el runtime de contenedores como servicios del sistema,
- consultar la salud del API server.

Lo que crees va en el namespace `lab-02`, que se crea solo al arrancar. Los manifiestos están en `/root/lab`.

Cómo usarlo:

- Haz clic en un comando para ejecutarlo en la terminal.
- Si un paso tiene **CHECK**, el escenario comprueba el estado del clúster antes de dejarte avanzar. Los pasos de solo observación se pasan con **NEXT**.
- La sesión dura como máximo una hora y el clúster se borra al terminar.

Espera a que la terminal muestre los dos nodos y pulsa **START**.
