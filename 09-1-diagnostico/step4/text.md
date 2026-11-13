`kubectl port-forward` abre un túnel desde la máquina donde corre `kubectl` hasta un Pod o un Service, sin crear NodePort ni Ingress. Aquí kubectl corre en `controlplane`; con `--address 0.0.0.0` el túnel también acepta conexiones desde fuera, para poder abrirlo en el navegador:

`kubectl port-forward -n lab-09 svc/frontend 8081:80 --address 0.0.0.0`{{exec}}

```text
Forwarding from 0.0.0.0:8081 -> 80
```

Abre [el frontend en el puerto 8081]({{TRAFFIC_HOST1_8081}}): verás la página de bienvenida de nginx. Cada petición deja una línea `Handling connection for 8081` en la terminal.

Vuelve a la terminal y corta el túnel con `Ctrl+C`.

**Qué observar**

- El túnel pasa por el apiserver: no expone nada de forma permanente y desaparece al cortarlo.
- Es la forma rápida de responder a «¿la app responde?», separando el problema de la aplicación del problema de red o de Ingress.
- En un portátil escribirías `kubectl port-forward svc/frontend 8081:80` y abrirías `http://localhost:8081`. El `--address 0.0.0.0` solo hace falta aquí, porque tu navegador no está en la misma máquina que kubectl.

Este paso no tiene CHECK. Pulsa **Siguiente** para terminar.
