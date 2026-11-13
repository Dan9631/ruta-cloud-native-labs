# GitOps con Argo CD

Este escenario es la tercera parte del laboratorio del módulo 12 de **Ruta Cloud Native**. Trabajas en un clúster real de Kubernetes con dos nodos: `controlplane` y `node01`.

En unos 45 minutos vas a:

- instalar Argo CD con una versión fijada,
- montar un servidor Git **dentro del clúster** con el repo de la aplicación,
- crear una Application y ver cómo Argo CD despliega lo que hay en Git,
- cambiar el clúster a mano y ver cómo Argo CD lo deshace (*selfHeal*),
- hacer el cambio correcto, con un commit,
- resolver el reto GitOps del módulo usando solo commits.

```text
 terminal (git clone/commit/push)
        |  port-forward 9418
        v
 lab-12: git-server (git daemon, repo app.git)  <---  argocd: repo-server lee git://
 lab-12: gitops-web (Deployment + Service)      <---  argocd: application-controller sincroniza
```

**Diferencias con el laboratorio local del curso**

- Este clúster tiene 4 GB de memoria en total. Por eso se instala Argo CD **core**, el manifiesto oficial reducido: controlador, repo-server y Redis, sin servidor de API ni interfaz web, sin Dex (SSO) y sin notificaciones. Todo se maneja con `kubectl`, que es justo lo que hace un agente GitOps: leer y escribir recursos de Kubernetes.
- La interfaz web queda como paso opcional al final, servida por HTTP desde la propia terminal.
- El repo del servidor Git vive en un `emptyDir` en vez de en un PVC.

La primera vez Argo CD tarda unos minutos en descargar sus imágenes. Es la parte más pesada del módulo: si algo no arranca, el paso 1 te dice cómo verlo.

Cómo usarlo:

- Haz clic en un comando para ejecutarlo en la terminal.
- Al final de cada paso pulsa **CHECK**: el escenario comprueba el estado del clúster antes de dejarte avanzar.
- La sesión dura como máximo una hora y el clúster se borra al terminar.

Espera a que la terminal muestre los dos nodos y pulsa **START**.
