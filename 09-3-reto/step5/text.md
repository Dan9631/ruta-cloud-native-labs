**Caso 6 · `shop`** — archivo `/root/lab/rotos/06-shop.yaml`. Es el jefe final: tiene **dos** fallos.

**Síntoma:** se reinicia solo **y** su Service no responde.

`kubectl get pods -n lab-09 -l app=shop`{{exec}}

**Objetivo:** todo el namespace sano. Este CHECK es la comprobación final del laboratorio:

- los 6 Deployments (`frontend`, `api`, `cache`, `worker`, `reporter`, `shop`) con todas sus réplicas actualizadas y `READY x/x`,
- ningún Pod de las apps en `Pending`, `ImagePullBackOff`, `CrashLoopBackOff` ni `CreateContainerConfigError`,
- `RESTARTS` a 0 en todos los Pods actuales (si un Pod viejo acumuló reinicios antes de tu arreglo, `kubectl rollout restart deployment/<nombre> -n lab-09`),
- el Service `shop` con al menos 2 endpoints listos y respondiendo por HTTP dentro del clúster.

**Pistas**

- Primer fallo: los logs de nginx no muestran nada raro. Entonces, ¿quién mata al contenedor? Busca eventos `Unhealthy` y `Killing` y compara el puerto que pregunta la sonda con el puerto donde escucha nginx.
- Segundo fallo: un Service solo envía tráfico a Pods que coinciden con su `selector` **y** están Ready. Compara el `Selector` de `kubectl describe svc` con `kubectl get pods --show-labels`.
- Para ver las direcciones reales del Service: `kubectl get endpointslices -n lab-09 -l kubernetes.io/service-name=shop`.

Cuando creas que está, pulsa **CHECK**.

**Si te atascas**

`cat /root/solucion/caso6-shop.txt`{{copy}}
