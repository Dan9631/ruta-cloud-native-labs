# Segunda parte terminada

Has visto que:

- un Deployment gestiona ReplicaSets, y cada cambio en la plantilla de Pod crea uno nuevo,
- el rolling update sustituye los Pods poco a poco y se detiene solo si los nuevos no arrancan,
- `rollout undo` vuelve a la plantilla anterior porque el ReplicaSet viejo se conserva,
- `kubectl apply` es idempotente,
- un ConfigMap y un Secret llegan al contenedor como variables o como archivos, y base64 no es cifrado,
- un Job termina y un CronJob crea Jobs según un horario.

Queda el reto: **Módulo 03 (3 de 3) · Reto**. Allí no hay comandos para copiar: construyes una aplicación con lo que has practicado y el escenario la comprueba.
