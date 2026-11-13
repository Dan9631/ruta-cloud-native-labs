Primera pregunta de cualquier monitoreo: ¿qué targets están arriba? Cuéntalos por job con una agregación:

`promql 'count by (job) (up)'`{{exec}}

```text
{job="kubernetes-api-servers"}  1
{job="kubernetes-nodes"}  2
{job="kubernetes-nodes-cadvisor"}  2
{job="kubernetes-service-endpoints"}  ...
{job="prometheus"}  1
...
```

Los targets caídos son los que cumplen `up == 0`. Lo ideal es un resultado vacío:

`promql 'up == 0'`{{exec}}

Filtra por label con `=`, `!=`, `=~` (expresión regular) y `!~`:

`promql 'up{job="kubernetes-nodes"}'`{{exec}}

`promql 'up{job=~"kubernetes-nodes.*"}'`{{exec}}

`promql 'up{job!~"kubernetes-.*"}'`{{exec}}

Si estás en la interfaz web, mira también **Status → Target health**: es la misma información, por *scrape pool*.

**Qué observar**

- `count by (job)` agrupa las series por el label `job` y cuenta cuántas hay en cada grupo. Otras agregaciones: `sum`, `avg`, `max`, `min`, `topk`.
- Una comparación como `up == 0` no devuelve verdadero o falso: **filtra** y deja solo las series que la cumplen. Así se escriben las alertas.
- Con 2 nodos hay 2 targets de `kubernetes-nodes` y 2 de `kubernetes-nodes-cadvisor` (en el lab local del curso, con 3 nodos, eran 3).
- `=~` admite expresiones regulares: `kubernetes-nodes.*` encaja con `kubernetes-nodes` y con `kubernetes-nodes-cadvisor`.

Este paso no tiene comprobación. Pulsa **NEXT**.
