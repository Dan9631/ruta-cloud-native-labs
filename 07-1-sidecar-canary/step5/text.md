`04-httproute-canary-50-50.yaml` es la misma ruta (`canary`) con pesos 50/50. `kubectl apply` la actualiza en caliente:

`diff /root/lab/03-httproute-canary.yaml /root/lab/04-httproute-canary-50-50.yaml`{{exec}}

`kubectl apply -f /root/lab/04-httproute-canary-50-50.yaml`{{exec}}

```text
httproute.gateway.networking.k8s.io/canary configured
```

Vuelve a contar las respuestas:

`for i in $(seq 20); do curl -s $GW/lab07/canary | grep '^Name:'; done | sort | uniq -c`{{exec}}

```text
     10 Name: v1
     10 Name: v2
```

Comprueba que los Pods no se han tocado (fíjate en la columna AGE y en RESTARTS):

`kubectl get pods -n lab-07 -l app=whoami`{{exec}}

**Qué observar**

- No se reinició ningún Pod; solo cambió la configuración del proxy. Así trabaja un mesh o un gateway: el control plane reprograma el data plane.
- Para terminar el rollout pondrías `weight: 0` en v1 (o lo quitarías) y luego borrarías el Deployment viejo; para un rollback, al revés.

Pulsa **CHECK**.
