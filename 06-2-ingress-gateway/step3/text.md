`kubectl port-forward` abre un túnel desde tu máquina, a través del API server y el kubelet, hasta un Pod del Service. Lánzalo en segundo plano. `--address 0.0.0.0` hace que escuche también fuera de `localhost`, para poder abrirlo en el navegador:

`kubectl port-forward -n lab-06 svc/whoami 9006:80 --address 0.0.0.0 > /tmp/port-forward.log 2>&1 &`{{exec}}

`sleep 3; curl -s http://localhost:9006 | grep Hostname`{{exec}}

```text
Hostname: whoami-6bb7cb8689-rlrjv
```

Repite el `curl` varias veces:

`for i in 1 2 3; do curl -s http://localhost:9006 | grep Hostname; done`{{exec}}

En el navegador: [whoami por el port-forward]({{TRAFFIC_HOST1_9006}}).

**Qué observar**

- El túnel funciona sin Service NodePort ni Ingress.
- Siempre responde el mismo Pod: port-forward no balancea, elige un Pod al abrirse.
- Es solo para depurar: muere al cerrar la terminal o al pararlo. No es una forma de exponer aplicaciones.

Pulsa **CHECK** con el túnel abierto. Después puedes cerrarlo con `pkill -f 'kubectl port-forward -n lab-06'`{{exec}}.
