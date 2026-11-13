Consulta la documentación de los campos que has usado, directamente desde el clúster:

`kubectl explain hpa.spec.behavior.scaleDown --api-version=autoscaling/v2`{{exec}}

¿Qué versiones de la API de autoscaling hay?

`kubectl api-versions | grep autoscaling`{{exec}}

```text
autoscaling/v1
autoscaling/v2
```

Un HPA también se puede crear de forma imperativa. Mira el manifiesto que generaría, sin crear nada:

`kubectl autoscale deployment php-apache -n lab-10 --min=2 --max=5 --cpu=50% --dry-run=client -o yaml`{{exec}}

**Qué observar**

- `autoscaling/v1` solo soporta CPU. `autoscaling/v2` añade memoria, métricas personalizadas y externas, y `behavior`. Usa siempre v2.
- `kubectl autoscale` es rápido, pero no rellena el bloque `behavior`: para eso necesitas YAML. Lo vas a necesitar en el reto.
- En versiones antiguas de kubectl la opción era `--cpu-percent=50`, hoy obsoleta.

Este paso no tiene comprobación. Pulsa **NEXT** para terminar.
