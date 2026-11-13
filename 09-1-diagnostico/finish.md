# Primera parte terminada

Has aplicado la metodología **de afuera hacia adentro**:

- `get` te dio el panorama: fase, motivo, reinicios, IP y nodo de cada Pod,
- `describe` y los eventos explicaron por qué `frontend` no arrancaba antes de que existiera un contenedor,
- `-o yaml` y jsonpath te llevaron al dato exacto (`state.waiting.reason`),
- `logs -l --prefix` leyó varios Pods a la vez y `exec` miró desde dentro de un contenedor vivo,
- un Pod cliente te mostró un Service que existe pero no tiene endpoints,
- `port-forward` probó la aplicación sin exponerla.

Siguiente escenario: **Módulo 09 (2 de 3) · kubectl debug, top y salud del clúster**. Después llega el reto: arreglar los cinco casos que quedan.

El clúster de esta sesión se borra al cerrar, así que no hace falta limpiar nada.
