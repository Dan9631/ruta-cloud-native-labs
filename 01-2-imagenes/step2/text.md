Ejecuta tu imagen como cualquier otra:

`podman run -d --name web2 -p 8082:80 kcna-web:1.0`{{exec}}

`curl -s http://localhost:8082`{{exec}}

`podman exec web2 printenv KCNA_MODULO`{{exec}}

```text
...
  <h1>Hola desde mi imagen KCNA v1</h1>
  <p>Construida con Podman a partir de nginx:1.27-alpine.</p>
...
01
```

También puedes [abrir tu página en el navegador]({{TRAFFIC_HOST1_8082}}).

**Qué observar**

- nginx sirve tu `index.html`: es el archivo que copió la instrucción `COPY`.
- La variable `ENV` del Containerfile está disponible dentro del contenedor.
- No escribiste `CMD`: el contenedor arranca nginx porque lo heredó de la base.

Pulsa **CHECK** con `web2` en marcha.
