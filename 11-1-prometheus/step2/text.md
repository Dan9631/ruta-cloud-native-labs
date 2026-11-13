Borra el Pod del paso anterior:

`kubectl delete pod registro -n lab-11 --now`{{exec}}

Añade el repositorio de charts de la comunidad de Prometheus y busca el chart:

`helm repo add prometheus-community https://prometheus-community.github.io/helm-charts`{{exec}}

`helm repo update prometheus-community`{{exec}}

`helm search repo prometheus-community/prometheus --versions | head -4`{{exec}}

```text
NAME                              CHART VERSION   APP VERSION   DESCRIPTION
prometheus-community/prometheus   29.37.2         v3.15.1       Prometheus is a monitoring system and time seri...
...
```

Puede que veas versiones más nuevas arriba: el lab usa siempre la **29.37.2**.

Revisa los valores con los que lo vas a instalar:

`cat /root/lab/prometheus-values.yaml`{{exec}}

Desactivan `alertmanager` y `prometheus-pushgateway`, dejan `kube-state-metrics` y `prometheus-node-exporter`, y quitan el volumen persistente del servidor.

Para saber qué imágenes usa un chart antes de instalarlo, renderízalo con `helm template` (no crea nada en el clúster) y filtra las líneas `image:`:

```
helm template prometheus prometheus-community/prometheus --version 29.37.2 -n lab-11 \
  -f /root/lab/prometheus-values.yaml | grep -oE 'image: *"?[^" ]+' | sed -E 's/image: *"?//' | sort -u
```{{exec}}

```text
quay.io/prometheus-operator/prometheus-config-reloader:v0.94.2
quay.io/prometheus/node-exporter:v1.12.1
quay.io/prometheus/prometheus:v3.15.1
registry.k8s.io/kube-state-metrics/kube-state-metrics:v2.20.0
```

**Qué observar**

- La versión del **chart** (29.37.2) es distinta de la versión de la **aplicación** (Prometheus v3.15.1). Fijamos la del chart para que el lab sea reproducible.
- Son 4 componentes: el servidor, un *config reloader* (sidecar que recarga la configuración cuando cambia el ConfigMap), node-exporter y kube-state-metrics.
- Las imágenes vienen de `quay.io` y `registry.k8s.io`, no de Docker Hub. `helm template` es la forma de saberlo sin instalar nada.

Pulsa **CHECK**.
