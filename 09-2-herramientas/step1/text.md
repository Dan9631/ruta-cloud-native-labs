Imagina que la imagen de `frontend` no tuviera shell ni herramientas, algo habitual con las imágenes *distroless*. `kubectl debug` puede añadir un **contenedor efímero** a un Pod en ejecución, con otra imagen. Con `--target` comparte el espacio de procesos del contenedor `nginx`.

Guarda el nombre de un Pod de `frontend`:

`POD=$(kubectl get pod -n lab-09 -l app=frontend -o jsonpath='{.items[0].metadata.name}'); echo $POD`{{exec}}

Inyecta un busybox. El perfil se indica siempre de forma explícita:

`kubectl debug -it $POD -n lab-09 --image=busybox:1.37 --target=nginx --profile=general -- sh`{{exec}}

Ya estás en la shell del depurador. Mira los procesos y los puertos en escucha, y sal:

`ps`{{exec}}

`netstat -tln`{{exec}}

`exit`{{exec}}

```text
PID   USER     TIME  COMMAND
    1 root      0:00 nginx: master process nginx -g daemon off;
   34 101       0:00 nginx: worker process
...
tcp        0      0 0.0.0.0:80              0.0.0.0:*               LISTEN
```

El contenedor efímero queda registrado en el Pod:

`kubectl get pod $POD -n lab-09 -o jsonpath='{.spec.ephemeralContainers[*].name}'; echo`{{exec}}

**Qué observar**

- Ves los procesos de nginx (el PID 1 es el *master*) aunque estás en otro contenedor con otra imagen: eso es `--target`.
- El contenedor efímero queda en `spec.ephemeralContainers`. **No se puede quitar ni modificar**: desaparece cuando el Pod se reemplaza. Tampoco se reinicia nunca ni admite `ports` ni sondas.
- `--profile` define los permisos del depurador: `general` (el valor por defecto en kubectl v1.37), `baseline`, `restricted`, `netadmin` y `sysadmin` (privilegiado).

Pulsa **CHECK**.
