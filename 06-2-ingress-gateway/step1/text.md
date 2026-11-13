Mira primero el Ingress Controller que se instaló al arrancar:

`kubectl get pods,svc -n traefik`{{exec}}

`kubectl get ingressclass`{{exec}}

```text
NAME                CONTROLLER                      PARAMETERS   AGE
traefik (default)   traefik.io/ingress-controller   <none>       9m
```

El Service `traefik` es de tipo NodePort: su puerto 80 (`web`) se abre en el **30800** de cada nodo.

Ahora el Ingress: una regla HTTP que manda `/lab06/ingress` al Service `whoami`:

`cat /root/lab/05-ingress.yaml`{{exec}}

`kubectl apply -f /root/lab/05-ingress.yaml`{{exec}}

`kubectl get ingress -n lab-06`{{exec}}

```text
NAME     CLASS     HOSTS   ADDRESS   PORTS   AGE
whoami   traefik   *                 80      5s
```

Guarda la IP del nodo y pide la página 3 veces con **un solo** `curl`, es decir, por la misma conexión:

`CP=$(kubectl get node controlplane -o jsonpath='{.status.addresses[?(@.type=="InternalIP")].address}'); echo $CP`{{exec}}

`curl -s http://$CP:30800/lab06/ingress http://$CP:30800/lab06/ingress http://$CP:30800/lab06/ingress | grep Hostname`{{exec}}

```text
Hostname: whoami-6bb7cb8689-rlrjv
Hostname: whoami-6bb7cb8689-hr2rj
Hostname: whoami-6bb7cb8689-6kg4c
```

Prueba una ruta que no existe:

`curl -s http://$CP:30800/otra-cosa`{{exec}}

```text
404 page not found
```

También puedes abrirlo en el navegador: [whoami por el Ingress]({{TRAFFIC_HOST1_30800}}/lab06/ingress).

**Qué observar**

- El objeto Ingress por sí solo no hace nada: lo atiende el controlador de la IngressClass `traefik`.
- Aquí el reparto es por **petición** aunque haya keep-alive, porque Traefik es un proxy L7 que abre sus propias conexiones a los Pods (usa los EndpointSlices directamente, sin pasar por la ClusterIP). Compáralo con el NodePort de la primera parte.
- Si ninguna regla coincide, Traefik responde `404 page not found`.

Pulsa **CHECK**.
