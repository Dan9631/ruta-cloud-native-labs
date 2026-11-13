Provoca dos cambios «no autorizados»: escala el Deployment y borra el Service.

`kubectl scale deploy gitops-web -n lab-12 --replicas=5 && kubectl delete svc gitops-web -n lab-12`{{exec}}

Mira el Deployment durante 30 segundos:

`timeout 30 kubectl get deploy gitops-web -n lab-12 -w`{{exec}}

```text
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
gitops-web   2/5     5            2           74s
gitops-web   2/2     2            2           80s
...
```

`kubectl get svc gitops-web -n lab-12`{{exec}}

```text
NAME         TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
gitops-web   ClusterIP   10.96.63.124   <none>        80/TCP    6s
```

Los eventos de la Application cuentan lo que pasó:

`kubectl get events -n argocd --field-selector involvedObject.name=gitops-demo --sort-by=.lastTimestamp -o custom-columns='REASON:.reason,MESSAGE:.message'`{{exec}}

```text
ResourceUpdated      Updated sync status: Synced -> OutOfSync
OperationStarted     Initiated automated sync to '876dd25b...'
OperationCompleted   Partial sync operation to 876dd25b... succeeded
ResourceUpdated      Updated sync status: OutOfSync -> Synced
```

**Qué observar**

- En segundos las réplicas vuelven a 2 y el Service reaparece, con otra ClusterIP y un AGE de pocos segundos: es un objeto nuevo.
- Eso es **selfHeal**: el estado deseado está en Git y el agente reconcilia de forma continua. Es lo mismo que hiciste a mano con `kubectl diff` y `kubectl apply -k` en el escenario de Kustomize, pero automático.

Pulsa **CHECK** cuando el Deployment haya vuelto a 2 réplicas y el Service exista de nuevo.
