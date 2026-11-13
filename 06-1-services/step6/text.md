Hasta ahora todo se probó desde dentro del clúster. Un Service **NodePort** abre el mismo puerto en **todos** los nodos:

`cat /root/lab/04-svc-nodeport.yaml`{{exec}}

`kubectl apply -f /root/lab/04-svc-nodeport.yaml`{{exec}}

`kubectl get svc whoami-nodeport -n lab-06`{{exec}}

```text
NAME              TYPE       CLUSTER-IP     EXTERNAL-IP   PORT(S)        AGE
whoami-nodeport   NodePort   10.96.65.206   <none>        80:30080/TCP   3s
```

Guarda la IP de cada nodo en una variable:

`CP=$(kubectl get node controlplane -o jsonpath='{.status.addresses[?(@.type=="InternalIP")].address}'); N1=$(kubectl get node node01 -o jsonpath='{.status.addresses[?(@.type=="InternalIP")].address}'); echo "controlplane=$CP node01=$N1"`{{exec}}

Pide la página 4 veces con **un solo** `curl`. curl reutiliza la misma conexión TCP (*keep-alive*) para las cuatro:

`curl -s http://$CP:30080 http://$CP:30080 http://$CP:30080 http://$CP:30080 | grep Hostname`{{exec}}

```text
Hostname: whoami-6bb7cb8689-hr2rj
Hostname: whoami-6bb7cb8689-hr2rj
Hostname: whoami-6bb7cb8689-hr2rj
Hostname: whoami-6bb7cb8689-hr2rj
```

Ahora con 4 `curl` distintos, cada uno con su propia conexión, y contra el otro nodo:

`for i in 1 2 3 4; do curl -s http://$N1:30080 | grep Hostname; done`{{exec}}

```text
Hostname: whoami-6bb7cb8689-hr2rj
Hostname: whoami-6bb7cb8689-hr2rj
Hostname: whoami-6bb7cb8689-6kg4c
Hostname: whoami-6bb7cb8689-rlrjv
```

También puedes abrirlo en el navegador: [whoami por el NodePort 30080]({{TRAFFIC_HOST1_30080}}). Si recargas, verás a menudo el mismo Pod: el navegador también reutiliza la conexión.

**Qué observar**

- Con una sola conexión, ¡siempre el mismo Pod! kube-proxy balancea **por conexión**, no por petición HTTP.
- Con conexiones nuevas, sí se reparte.
- El puerto 30080 responde en los dos nodos, tengan o no un Pod de whoami: kube-proxy lo abre en todos y reenvía el tráfico al Pod que toque.
- Un NodePort también tiene ClusterIP: los tipos de Service se apilan.

Pulsa **CHECK**.
