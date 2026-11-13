Mira el contenedor desde dentro con `podman exec`:

`podman exec web1 ps`{{exec}}

`podman exec web1 hostname`{{exec}}

`podman exec web1 cat /etc/os-release`{{exec}}

`podman exec web1 uname -r`{{exec}}

```text
PID   USER     TIME  COMMAND
    1 root      0:00 nginx: master process nginx -g daemon off;
   25 nginx     0:00 nginx: worker process
   ...
   29 root      0:00 ps
c90a6331da02
NAME="Alpine Linux"
ID=alpine
...
6.8.0-...-generic
```

Compara con la máquina:

`hostname; uname -r; grep PRETTY_NAME /etc/os-release`{{exec}}

`ps -o pid,user,cmd -C nginx`{{exec}}

```text
    PID USER     CMD
   4120 root     nginx: master process nginx -g daemon off;
   4152 101      nginx: worker process
```

Ahora escribe un archivo dentro del contenedor y búscalo fuera:

`podman exec web1 sh -c 'echo hola desde web1 > /tmp/nota.txt'`{{exec}}

`podman exec web1 cat /tmp/nota.txt`{{exec}}

`ls /tmp/nota.txt`{{exec}}

```text
hola desde web1
ls: cannot access '/tmp/nota.txt': No such file or directory
```

**Qué observar**

- Gracias al namespace `pid`, nginx es el **PID 1** dentro y no se ven los procesos de la máquina. Desde fuera, el mismo proceso tiene otro PID.
- El namespace `uts` le da como hostname el ID del contenedor.
- El namespace `mnt` le da su propio filesystem: Alpine dentro, Ubuntu fuera. El archivo que escribiste vive en la **capa escribible** del contenedor, no en la máquina.
- Pero el **kernel es el de la máquina**: `uname -r` da lo mismo dentro y fuera. Un contenedor no trae kernel propio.
- El proceso maestro corre como `root` y los *workers* como `nginx` (fuera se ve su UID, o el nombre que ese UID tenga en la máquina).

Pulsa **CHECK**.
