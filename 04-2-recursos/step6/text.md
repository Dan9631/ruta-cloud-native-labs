Limpia el paso anterior:

`kubectl delete pod otro-scheduler critico -n lab-04`{{exec}}

`kubectl delete priorityclass lab-04-alta`{{exec}}

El Deployment de este paso reparte sus réplicas entre los valores de la label `zone` de los nodos, con una diferencia máxima de 1:

`grep -A 6 topologySpreadConstraints /root/lab/18-spread.yaml`{{exec}}

`kubectl apply -f /root/lab/18-spread.yaml`{{exec}}

`kubectl scale deploy web-repartida -n lab-04 --replicas=5`{{exec}}

`kubectl rollout status deploy/web-repartida -n lab-04`{{exec}}

`kubectl get pods -n lab-04 -o custom-columns='POD:.metadata.name,NODO:.spec.nodeName' --sort-by=.spec.nodeName`{{exec}}

```text
POD                             NODO
web-repartida-f79c69c74-7crgz   controlplane
web-repartida-f79c69c74-jcgb4   controlplane
web-repartida-f79c69c74-v6pdm   controlplane
web-repartida-f79c69c74-cffdf   node01
web-repartida-f79c69c74-q2fbk   node01
```

**Qué observar**

- Con `maxSkew: 1`, las 5 réplicas quedan 3 y 2 entre `zona-a` (`controlplane`) y `zona-b` (`node01`), en un orden u otro; nunca 4 y 1.
- Aquí cada zona es un solo nodo. En un clúster real una zona agrupa varios nodos y la regla reparte por zona, no por nodo.
- Spread es más flexible que la pod anti-affinity: anti-affinity dice «como máximo uno por dominio» (con 2 nodos, una tercera réplica quedaría `Pending`), spread dice «repártelos con una diferencia máxima de N».

Pulsa **CHECK**.
