Un Job ejecuta una tarea hasta completarla. Un CronJob crea Jobs según un horario.

`cat /root/lab/jobs.yaml`{{exec}}

`kubectl apply -f /root/lab/jobs.yaml`{{exec}}

`kubectl wait --for=condition=Complete job/calculo -n lab-03 --timeout=120s`{{exec}}

`kubectl get jobs,pods -n lab-03 -l batch.kubernetes.io/job-name=calculo`{{exec}}

```text
NAME                STATUS     COMPLETIONS   DURATION   AGE
job.batch/calculo   Complete   3/3           23s        28s
NAME                READY   STATUS      RESTARTS   AGE
pod/calculo-8t4sz   0/1     Completed   0          27s
pod/calculo-ps5wz   0/1     Completed   0          15s
pod/calculo-qqwfs   0/1     Completed   0          27s
```

`kubectl logs job/calculo -n lab-03`{{exec}}

El CronJob dispara cada minuto. Espera uno o dos minutos y mira los Jobs que ha creado:

`kubectl get cronjob,jobs -n lab-03`{{exec}}

```text
NAME                    SCHEDULE      TIMEZONE   SUSPEND   ACTIVE   LAST SCHEDULE   AGE
cronjob.batch/reporte   */1 * * * *   <none>     False     0        19s             2m29s
NAME                         STATUS     COMPLETIONS   DURATION   AGE
job.batch/calculo            Complete   3/3           23s        2m30s
job.batch/reporte-29879576   Complete   1/1           20s        79s
```

**Qué observar**

- El Job pedía 3 completados con paralelismo 2: dos Pods arrancaron a la vez y el tercero después. Compara sus edades.
- Los Pods terminados quedan en `Completed` para que puedas leer sus logs.
- El CronJob crea un Job por minuto, con un sufijo numérico.

Pulsa **CHECK** cuando el CronJob haya creado al menos un Job.
