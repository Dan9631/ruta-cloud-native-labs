# Reto superado

Has documentado sin guía la arquitectura real del clúster:

- etcd corre como static pod en el nodo del plano de control,
- la imagen del kube-apiserver dice exactamente qué versión del plano de control tienes,
- el directorio de static pods guarda los manifiestos de los componentes que arranca el kubelet,
- CoreDNS es un Deployment con sus réplicas, y un Deployment se declara con `apps/v1`,
- un contexto nuevo del kubeconfig se puede preparar sin cambiar el activo.

Con esto termina el laboratorio del módulo 02 de **Ruta Cloud Native**. Vuelve al curso para hacer el examen del módulo.
