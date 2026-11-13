Vuelve a 3 réplicas:

`kubectl scale deploy whoami -n lab-06 --replicas=3`{{exec}}

Crea dos Services especiales: uno headless (`clusterIP: None`) y uno ExternalName:

`cat /root/lab/07-svc-headless.yaml /root/lab/08-svc-externalname.yaml`{{exec}}

`kubectl apply -f /root/lab/07-svc-headless.yaml -f /root/lab/08-svc-externalname.yaml`{{exec}}

`kubectl get svc -n lab-06`{{exec}}

```text
NAME              TYPE           CLUSTER-IP     EXTERNAL-IP       PORT(S)
buscador          ExternalName   <none>         www.example.com   <none>
whoami            ClusterIP      10.96.29.208   <none>            80/TCP
whoami-headless   ClusterIP      None           <none>            80/TCP
```

Resuelve los dos nombres desde el cliente:

`kubectl exec -n lab-06 cliente -- nslookup whoami-headless.lab-06.svc.cluster.local`{{exec}}

```text
Name:   whoami-headless.lab-06.svc.cluster.local
Address: 10.244.2.7
Name:   whoami-headless.lab-06.svc.cluster.local
Address: 10.244.1.4
Name:   whoami-headless.lab-06.svc.cluster.local
Address: 10.244.2.5
```

`kubectl exec -n lab-06 cliente -- nslookup buscador.lab-06.svc.cluster.local`{{exec}}

```text
buscador.lab-06.svc.cluster.local   canonical name = www.example.com
Name:   www.example.com
Address: ...
```

**Qué observar**

- El headless no tiene ClusterIP y su nombre devuelve **las IPs de los Pods**: sin IP virtual ni balanceo de kube-proxy. Es lo que usan los StatefulSets y los clientes que eligen Pod.
- El ExternalName es solo un **CNAME**: sin selector, sin endpoints y sin proxy. CoreDNS reenvía la resolución del nombre externo al DNS del nodo.

Pulsa **CHECK**.
