Mira qué cambia **prod**: réplicas, versión de imagen y un *patch* de recursos.

`cat /root/lab/kustomize/overlays/prod/kustomization.yaml /root/lab/kustomize/overlays/prod/recursos-patch.yaml`{{exec}}

Aplica los dos overlays:

`kubectl apply -k /root/lab/kustomize/overlays/dev`{{exec}}

`kubectl apply -k /root/lab/kustomize/overlays/prod`{{exec}}

```text
service/dev-web created
deployment.apps/dev-web created
service/prod-web created
deployment.apps/prod-web created
```

Espera a que estén listos y compáralos:

`kubectl rollout status deploy/prod-web -n lab-12`{{exec}}

`kubectl get deploy -n lab-12 -o custom-columns='NAME:.metadata.name,READY:.status.readyReplicas,IMAGE:.spec.template.spec.containers[0].image,ENV:.metadata.labels.env'`{{exec}}

```text
NAME       READY   IMAGE               ENV
dev-web    1       nginx:1.27-alpine   dev
prod-web   3       nginx:1.28-alpine   prod
```

Ahora comprueba que los Services no se mezclan. Cada EndpointSlice lista los Pods a los que envía tráfico su Service:

`kubectl get endpointslices -n lab-12`{{exec}}

```text
NAME             ADDRESSTYPE   PORTS   ENDPOINTS                                AGE
dev-web-gh59k    IPv4          80      10.244.2.141                             18s
prod-web-vgm74   IPv4          80      10.244.2.142,10.244.1.119,10.244.2.143   13s
```

Las IP serán otras en tu clúster.

`kubectl get svc -n lab-12 -o custom-columns='NAME:.metadata.name,SELECTOR:.spec.selector'`{{exec}}

**Qué observar**

- **La misma base** produce dos despliegues distintos. Prod cambia las réplicas (`replicas:`), la versión de imagen (`images:`) y los recursos (el patch de `recursos-patch.yaml`).
- `dev-web` tiene 1 endpoint y `prod-web` 3. Sin la etiqueta `env` en los selectores, los dos Services seleccionarían los 4 Pods, porque todos llevan `app: web`.

Pulsa **CHECK** cuando los dos Deployments estén listos.
