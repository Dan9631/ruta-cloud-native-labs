El controlador de EndpointSlices guarda las IPs de los Pods `Ready` que cumplen el selector del Service. Míralo y luego escala:

`kubectl get endpointslices -n lab-06 -l kubernetes.io/service-name=whoami`{{exec}}

`kubectl scale deploy whoami -n lab-06 --replicas=5`{{exec}}

`kubectl rollout status deploy/whoami -n lab-06`{{exec}}

`kubectl get endpointslices -n lab-06 -l kubernetes.io/service-name=whoami`{{exec}}

`kubectl get endpoints whoami -n lab-06`{{exec}}

```text
NAME           ADDRESSTYPE   PORTS   ENDPOINTS                                      AGE
whoami-mwpbl   IPv4          80      10.244.2.5,10.244.1.4,10.244.2.7 + 2 more...   13m
Warning: v1 Endpoints is deprecated in v1.33+; use discovery.k8s.io/v1 EndpointSlice
NAME     ENDPOINTS                                                 AGE
whoami   10.244.1.10:80,10.244.1.4:80,10.244.2.16:80 + 2 more...   13m
```

Opcional: mira las reglas que kube-proxy escribió en este nodo para el Service (una DNAT por cada Pod):

`iptables-save -t nat | grep "lab-06/whoami:http" | grep DNAT`{{exec}}

```text
-A KUBE-SEP-2MOBOHLTD3VI34EG -p tcp -m comment --comment "lab-06/whoami:http" -m tcp -j DNAT --to-destination 10.244.2.7:80
...
```

Si no sale nada, tu kube-proxy no está en modo iptables (o el CNI lo sustituye con eBPF).

**Qué observar**

- Al escalar, el controlador añade las nuevas IPs al EndpointSlice sin que toques el Service.
- El objeto `Endpoints` antiguo sigue existiendo, pero el API avisa de que está obsoleto.
- kube-proxy no está en el camino del paquete: solo escribe reglas en el kernel que traducen `ClusterIP:puerto` a `IPdelPod:targetPort`.

Pulsa **CHECK** con las 5 réplicas listas. Al empezar el paso siguiente volverás a 3.
