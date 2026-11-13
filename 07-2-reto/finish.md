# Reto superado

Has construido sin guía las dos piezas que están debajo de cualquier service mesh:

- un Pod con un **native sidecar** (`shipper`) que recoge lo que escribe la aplicación sin que ella lo sepa,
- una **HTTPRoute** que combina una regla por cabecera, más específica, con un reparto por pesos para el resto del tráfico: el canary que QA puede forzar a voluntad.

Curiosidad: mira la ruta con `kubectl get httproute reto-canary -n lab-07 -o yaml`. El `backendRef` de la regla de la cabecera tiene `weight: 1`, aunque no lo escribieras: el API server rellena el valor por defecto.

Con esto termina el laboratorio del módulo 07 de **Ruta Cloud Native**. Vuelve al curso para hacer el examen del módulo.
