# Segunda parte terminada

Ya tienes las herramientas para cuando `get`, `describe` y `logs` no bastan:

- un **contenedor efímero** añade herramientas a un Pod vivo sin reiniciarlo (y no se puede quitar),
- una **copia del Pod** con otro comando permite explorar un contenedor que no para de caerse, sin labels que lo mezclen con el original,
- `kubectl top` mide el consumo real frente a `requests` y `limits`,
- los componentes del control plane son static pods en `/etc/kubernetes/manifests`, y `/readyz` resume su salud,
- el kubelet es un servicio systemd: se lee con `systemctl` y `journalctl`, y `crictl` habla con el runtime por CRI.

Siguiente escenario: **Módulo 09 (3 de 3) · Reto**. Te esperan `api`, `cache`, `worker`, `reporter` y `shop`.

El clúster de esta sesión se borra al cerrar, así que no hace falta limpiar nada.
