Comprueba que Prometheus está en marcha:

`kubectl get pods -n lab-11`{{exec}}

Abre un port-forward hacia su Service. Escucha en todas las interfaces (`--address 0.0.0.0`) para que llegue el navegador, y queda en segundo plano:

`kubectl port-forward --address 0.0.0.0 -n lab-11 svc/prometheus-server 9090:80 > /tmp/port-forward.log 2>&1 &`{{exec}}

`sleep 2; curl -s localhost:9090/-/ready; echo`{{exec}}

Abre la interfaz: **[Prometheus en el puerto 9090]({{TRAFFIC_HOST1_9090}})**. En la pestaña **Query** escribes una consulta, pulsas **Execute** y alternas entre **Table** y **Graph**.

La interfaz usa una API HTTP que también puedes llamar tú. Prueba la consulta más sencilla, `up`:

`curl -sG localhost:9090/api/v1/query --data-urlencode 'query=up' | head -c 600; echo`{{exec}}

```text
{"status":"success","data":{"resultType":"vector","result":[{"metric":{"__name__":"up","instance":"...","job":"..."},"value":[1792776200.216,"1"]},...
```

La misma API está detrás del Service, así que también llega por el proxy del apiserver, sin port-forward. Eso hace el comando `promql`: codifica la consulta, llama a `kubectl get --raw` y muestra una línea por serie.

`promql 'up'`{{exec}}

`promql 'count(up == 1)'`{{exec}}

En los pasos siguientes, cada consulta va como comando `promql`. Si prefieres el navegador, copia solo lo que va entre comillas simples y pégalo en **Query**.

**Qué observar**

- Cada resultado es una **serie**: un nombre, unos labels y un valor con su marca de tiempo (segundos desde 1970).
- `up` vale 1 si el último scrape del target funcionó y 0 si falló: el propio fallo es una señal.
- La interfaz web, `curl` y `promql` usan la misma API (`/api/v1/query`).

Pulsa **CHECK** con el port-forward funcionando.
