# Helm: chart propio, upgrade y rollback

Este escenario es la segunda parte del laboratorio del módulo 12 de **Ruta Cloud Native**. Trabajas en un clúster real de Kubernetes con dos nodos: `controlplane` y `node01`.

En unos 30 minutos vas a:

- leer un chart de Helm pequeño y renderizarlo sin instalarlo,
- instalarlo como un **release** y ver la página que sirve,
- actualizarlo con otro archivo de values,
- ver dónde guarda Helm el historial de revisiones,
- volver a una revisión anterior con un rollback.

Todo se hace en el namespace `lab-12`, que se crea solo al arrancar. El chart está en `/root/lab/helm`:

```text
helm/
  saludo/            Chart.yaml, values.yaml, templates/
  values-v2.yaml     los values del upgrade
```

Si `helm` no viene instalado en el entorno, se instala solo al arrancar.

Cómo usarlo:

- Haz clic en un comando para ejecutarlo en la terminal.
- Al final de cada paso pulsa **CHECK**: el escenario comprueba el estado del clúster antes de dejarte avanzar.
- La sesión dura como máximo una hora y el clúster se borra al terminar.

Espera a que la terminal muestre la versión de helm y los dos nodos, y pulsa **START**.
