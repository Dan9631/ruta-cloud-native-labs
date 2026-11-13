Instala el chart como un release llamado `saludo`:

`helm install saludo /root/lab/helm/saludo -n lab-12`{{exec}}

```text
NAME: saludo
NAMESPACE: lab-12
STATUS: deployed
REVISION: 1
...
```

`helm list -n lab-12`{{exec}}

```text
NAME    NAMESPACE  REVISION  UPDATED   STATUS    CHART         APP VERSION
saludo  lab-12     1         ...       deployed  saludo-0.1.0  1.27
```

Las notas del final de la instalación salen de `templates/NOTES.txt`. Espera al Pod y pide la página desde dentro del contenedor:

`kubectl rollout status deploy/saludo -n lab-12`{{exec}}

`kubectl exec deploy/saludo -n lab-12 -- wget -qO- http://localhost/`{{exec}}

```text
<h1>Hola desde Helm (v1)</h1>
<p>Release: saludo - Revision: 1 - Imagen: nginx:1.27-alpine</p>
```

**Opcional: verla en el navegador.** Abre un port-forward en segundo plano que escuche en todas las interfaces:

`kubectl port-forward -n lab-12 svc/saludo 8090:80 --address 0.0.0.0 > /tmp/pf-saludo.log 2>&1 &`{{exec}}

Y abre [la página del release]({{TRAFFIC_HOST1_8090}}).

**Qué observar**

- `helm install` crea la **revisión 1** del release.
- `APP VERSION` sale de `appVersion` en `Chart.yaml`: es informativa. La versión del chart (`0.1.0`) es la del empaquetado.

Pulsa **CHECK** cuando el Deployment esté listo.
