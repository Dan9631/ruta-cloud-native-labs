# Tu imagen en Kubernetes

Este escenario es la tercera parte del laboratorio del módulo 01 de **Ruta Cloud Native**. Trabajas en un clúster real de Kubernetes con **un solo nodo**, `controlplane`, que también ejecuta Pods. En el mismo nodo tienes **Podman** para construir la imagen.

En unos 30 minutos vas a:

- construir tu imagen con Podman y comprobar que el runtime del nodo (containerd) no la ve,
- importarla en containerd, que es lo que hace un clúster local como kind cuando "carga" una imagen,
- ejecutarla como Pod y ver el contenedor con `crictl`,
- provocar el error `ImagePullBackOff` y leer su diagnóstico.

Se usa un solo nodo a propósito: la imagen se importa a mano en el nodo, así que el Pod tiene que ejecutarse en ese mismo nodo.

Todo se hace en el namespace `lab-01`, que se crea solo al arrancar. Los archivos están en `/root/lab`.

Cómo usarlo:

- Haz clic en un comando para ejecutarlo en la terminal.
- Al final de cada paso pulsa **CHECK**: el escenario comprueba el estado del clúster antes de dejarte avanzar.
- La sesión dura como máximo una hora y el clúster se borra al terminar.

La preparación puede tardar un par de minutos si hay que instalar Podman. Espera a que la terminal muestre el nodo y pulsa **START**.
