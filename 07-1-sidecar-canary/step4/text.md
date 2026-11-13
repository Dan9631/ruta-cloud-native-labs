La HTTPRoute `canary` se cuelga del Gateway `traefik-gateway` y reparte el path `/lab07/canary` entre los dos Services: 90 a v1 y 10 a v2.

`cat /root/lab/03-httproute-canary.yaml`{{exec}}

`kubectl apply -f /root/lab/03-httproute-canary.yaml`{{exec}}

`kubectl get httproute canary -n lab-07 -o jsonpath='{range .spec.rules[0].backendRefs[*]}{.name}={.weight} {end}'; echo`{{exec}}

```text
whoami-v1=90 whoami-v2=10
```

Haz una petición a través del Gateway (si la variable `GW` está vacía, repite el `export` del paso anterior):

`curl -s $GW/lab07/canary`{{exec}}

```text
Name: v1
Hostname: whoami-v1-6c8df6cbf6-fgnhn
IP: 10.x.x.x
RemoteAddr: 10.x.x.x:35468
GET /lab07/canary HTTP/1.1
Host: <IP de controlplane>:30080
X-Forwarded-For: ...
X-Forwarded-Server: traefik-67dd9f645-bj282
...
```

La petición pasó por Traefik: lo delatan las cabeceras `X-Forwarded-*`. Ahora manda 20 peticiones y cuenta qué versión respondió:

`for i in $(seq 20); do curl -s $GW/lab07/canary | grep '^Name:'; done | sort | uniq -c`{{exec}}

```text
     18 Name: v1
      2 Name: v2
```

Si quieres, repite con `seq 100`: saldrá 90 / 10.

También puedes abrir la ruta en el navegador y recargar varias veces: [abrir /lab07/canary]({{TRAFFIC_HOST1_30080}}/lab07/canary).

**Qué observar**

- El reparto sigue los **pesos** de la ruta, no el número de Pods: v1 tiene el doble de Pods, pero recibe 9 veces más tráfico.
- Traefik usa *weighted round robin*, por eso sale exacto; otros controladores eligen al azar y verás números cercanos (88/12, 91/9...).
- Con un Deployment solo, el canary sería aproximado a base de réplicas (9 Pods v1 + 1 Pod v2 detrás del mismo Service). Con pesos en la ruta, el porcentaje es independiente del número de Pods.

Pulsa **CHECK**.
