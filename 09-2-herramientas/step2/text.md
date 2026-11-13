El Pod de `api` está en `CrashLoopBackOff`:

`kubectl get pods -n lab-09 -l app=api`{{exec}}

No puedes hacer `exec` en un contenedor que se cae una y otra vez. La salida es una **copia del Pod** que, en vez de su comando, ejecute una shell:

`API=$(kubectl get pod -n lab-09 -l app=api -o jsonpath='{.items[0].metadata.name}'); echo $API`{{exec}}

`kubectl debug $API -n lab-09 -it --copy-to=api-debug --container=api --profile=general -- sh`{{exec}}

Dentro puedes inspeccionar variables, archivos y red. Mira las variables de entorno y sal:

`env | sort`{{exec}}

`exit`{{exec}}

La copia sigue ahí. Compara sus labels con las del Pod original:

`kubectl get pods -n lab-09 -l app=api --show-labels`{{exec}}

`kubectl get pod api-debug -n lab-09 --show-labels`{{exec}}

```text
NAME        READY   STATUS    RESTARTS   AGE   LABELS
api-debug   1/1     Running   0          6s    <none>
```

**Qué observar**

- La copia **no tiene labels** (salvo que uses `--keep-labels`): ningún Service le manda tráfico y el ReplicaSet no la cuenta ni la borra. Es tu «paciente de pruebas».
- Con `--set-image` la copia puede usar además otra imagen.
- La causa del fallo de `api` es parte del reto. Si quieres adelantar, el comando que la muestra es `kubectl logs -n lab-09 deploy/api --previous`.

Pulsa **CHECK**. La copia se borra al principio del paso siguiente.
