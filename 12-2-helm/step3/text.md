`values-v2.yaml` solo contiene lo que cambia: 2 réplicas, `nginx:1.28-alpine` y otro mensaje.

`cat /root/lab/helm/values-v2.yaml`{{exec}}

Actualiza el release con esos values:

`helm upgrade saludo /root/lab/helm/saludo -n lab-12 -f /root/lab/helm/values-v2.yaml`{{exec}}

```text
Release "saludo" has been upgraded. Happy Helming!
...
REVISION: 2
```

Mira qué values se pasaron y cómo quedó el Deployment:

`helm get values saludo -n lab-12`{{exec}}

```text
USER-SUPPLIED VALUES:
image:
  tag: 1.28-alpine
mensaje: Hola desde Helm (v2)
replicaCount: 2
```

`kubectl rollout status deploy/saludo -n lab-12`{{exec}}

`kubectl get deploy saludo -n lab-12 -o custom-columns='NAME:.metadata.name,REPLICAS:.spec.replicas,IMAGE:.spec.template.spec.containers[0].image'`{{exec}}

```text
NAME     REPLICAS   IMAGE
saludo   2          nginx:1.28-alpine
```

`kubectl exec deploy/saludo -n lab-12 -- wget -qO- http://localhost/`{{exec}}

Si abriste el port-forward del paso anterior, se cortó al desaparecer su Pod. Vuelve a lanzarlo y recarga [la página]({{TRAFFIC_HOST1_8090}}):

`pkill -f 'port-forward -n lab-12 svc/saludo'; kubectl port-forward -n lab-12 svc/saludo 8090:80 --address 0.0.0.0 > /tmp/pf-saludo.log 2>&1 &`{{exec}}

**Qué observar**

- La página ahora dice *v2*.
- El Deployment hizo un **rolling update** porque cambió la plantilla del Pod: la imagen y la anotación `checksum/html`, que es un hash del ConfigMap. Sin esa anotación, cambiar solo el mensaje no reiniciaría los Pods.
- `helm get values` muestra solo lo que tú pasaste; el resto sigue saliendo de `values.yaml`.

Pulsa **CHECK** cuando las 2 réplicas estén listas.
