Arranca un contenedor de nginx en segundo plano y publica su puerto 80 en el 8081 de la máquina:

`podman run -d --name web1 -p 8081:80 nginx:1.27-alpine`{{exec}}

`podman ps`{{exec}}

```text
CONTAINER ID  IMAGE                                COMMAND               CREATED        STATUS        PORTS                 NAMES
c90a6331da02  docker.io/library/nginx:1.27-alpine  nginx -g daemon o...  5 seconds ago  Up 5 seconds  0.0.0.0:8081->80/tcp  web1
```

Pídele la página:

`curl -s http://localhost:8081`{{exec}}

```text
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
```

También puedes [abrirla en el navegador]({{TRAFFIC_HOST1_8081}}).

Ahora mira sus logs y sus procesos desde fuera:

`podman logs web1`{{exec}}

`podman top web1`{{exec}}

```text
/docker-entrypoint.sh: Configuration complete; ready for start up
...
10.88.0.1 - - [13/Nov/2026:10:16:22 +0000] "GET / HTTP/1.1" 200 615 "-" "curl/8.5.0" "-"
USER   PID   PPID   %CPU   ELAPSED   TTY   TIME   COMMAND
root   1     0      0.000  1m27s     ?     0s     nginx: master process nginx -g daemon off;
nginx  25    1      0.000  1m26s     ?     0s     nginx: worker process
```

**Qué observar**

- `-d` deja el contenedor en segundo plano y `-p 8081:80` publica el puerto 80 del contenedor en el 8081 de la máquina.
- El nombre corto `nginx` se resolvió a `docker.io/library/nginx`.
- Los logs son lo que el proceso escribe en stdout/stderr (factor 11 de la aplicación de 12 factores). Tu petición `curl` aparece en el log de acceso.

Pulsa **CHECK** cuando `curl` te haya devuelto la página.
