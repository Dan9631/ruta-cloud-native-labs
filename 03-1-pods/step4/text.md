Estos tres Pods ejecutan una tarea corta. Dos tienen `restartPolicy: Never` y uno `Always`:

`cat /root/lab/pods-ciclo-vida.yaml`{{exec}}

`kubectl apply -f /root/lab/pods-ciclo-vida.yaml`{{exec}}

Espera unos 45 segundos y compara el STATUS que muestra kubectl con la fase real:

`kubectl get pods -n lab-03 termina-ok termina-error reinicia-siempre`{{exec}}

`kubectl get pods -n lab-03 termina-ok termina-error reinicia-siempre -o custom-columns='NAME:.metadata.name,PHASE:.status.phase,RESTARTS:.status.containerStatuses[0].restartCount'`{{exec}}

```text
NAME               PHASE       RESTARTS
termina-ok         Succeeded   0
termina-error      Failed      0
reinicia-siempre   Running     3
```

Mira por qué falló uno y qué hace el kubelet con el que se reinicia:

`kubectl logs termina-error -n lab-03`{{exec}}

`kubectl describe pod reinicia-siempre -n lab-03 | grep -E 'State:|Reason:|Exit Code|Back-off'`{{exec}}

**Qué observar**

- Con `Never`, salir con código 0 deja la fase en **Succeeded** (STATUS `Completed`) y salir con 1 la deja en **Failed** (STATUS `Error`).
- Con `Always`, el mismo fallo produce reinicios: RESTARTS sube y la fase sigue siendo `Running`.
- El STATUS de ese Pod alterna entre `Running`, `Error` y `CrashLoopBackOff` según el momento. El evento `Back-off restarting failed container` confirma que el kubelet espera cada vez más entre reinicios.

Pulsa **CHECK** cuando `reinicia-siempre` tenga al menos un reinicio.
