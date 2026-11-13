Genera tráfico desde dentro del Pod. El sidecar comparte red con nginx, así que `localhost` es nginx. La última petición pide una página que no existe:

`kubectl exec -n lab-07 web-con-sidecar -c log-tail -- sh -c 'for i in 1 2 3; do wget -qO- http://localhost/ > /dev/null; done; wget -qO- http://localhost/no-existe'`{{exec}}

```text
wget: server returned error: HTTP/1.1 404 Not Found
command terminated with exit code 1
```

Ese error es el esperado: es el 404 de `/no-existe`. Ahora lee los logs del sidecar:

`kubectl logs -n lab-07 web-con-sidecar -c log-tail`{{exec}}

```text
sidecar listo, esperando logs...
tail: can't open '/logs/access.log': No such file or directory
tail: /logs/access.log has appeared; following end of new file
127.0.0.1 - - [13/Nov/2026:16:08:10 +0000] "GET / HTTP/1.1" 200 615 "-" "Wget" "-"
127.0.0.1 - - [13/Nov/2026:16:08:10 +0000] "GET / HTTP/1.1" 200 615 "-" "Wget" "-"
127.0.0.1 - - [13/Nov/2026:16:08:10 +0000] "GET / HTTP/1.1" 200 615 "-" "Wget" "-"
127.0.0.1 - - [13/Nov/2026:16:08:10 +0000] "GET /no-existe HTTP/1.1" 404 153 "-" "Wget" "-"
```

Compara con los logs del contenedor de la aplicación:

`kubectl logs -n lab-07 web-con-sidecar -c nginx`{{exec}}

**Qué observar**

- El sidecar arrancó antes de que existiera el archivo (de ahí el `can't open`) y lo empezó a seguir en cuanto nginx lo creó.
- Nginx no sabe nada del sidecar: es el patrón en estado puro, ampliar sin modificar la app.
- En los logs de `nginx` no aparecen los accesos, porque ahora van al volumen.

Pulsa **CHECK**.
