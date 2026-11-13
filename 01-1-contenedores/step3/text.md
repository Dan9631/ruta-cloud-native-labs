Arranca un contenedor efímero con límites de memoria y CPU, y lee los archivos de cgroup que ve dentro:

`podman run --rm --memory 64m --cpus 0.5 busybox:1.37 sh -c 'cat /sys/fs/cgroup/memory.max; cat /sys/fs/cgroup/cpu.max; ps'`{{exec}}

```text
67108864
50000 100000
PID   USER     TIME  COMMAND
    1 root      0:00 ps
```

`--rm` lo borra al terminar. Ahora deja uno en marcha con los mismos límites para mirarlo desde fuera:

`podman run -d --name limitado --memory 64m --cpus 0.5 busybox:1.37 sleep 3600`{{exec}}

`podman exec limitado cat /sys/fs/cgroup/memory.max /sys/fs/cgroup/cpu.max`{{exec}}

`podman stats --no-stream limitado`{{exec}}

```text
ID            NAME      CPU %   MEM USAGE / LIMIT  MEM %  ...
3f1e2a9b7c4d  limitado  0.00%   225.3kB / 67.11MB  0.34%  ...
```

**Qué observar**

- `--memory 64m` se traduce en `memory.max = 67108864` bytes (64 MiB).
- `--cpus 0.5` se traduce en `cpu.max = 50000 100000`: 50 ms de CPU cada 100 ms.
- Es exactamente lo que hará Kubernetes con `resources.limits` de un contenedor.
- En el primer comando, `ps` es el PID 1: el contenedor solo ve su propio proceso.

Pulsa **CHECK** con el contenedor `limitado` en marcha.
