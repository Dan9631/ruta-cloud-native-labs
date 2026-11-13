# Ruta Cloud Native · laboratorios en el navegador

Escenarios de [Killercoda](https://killercoda.com) para hacer los laboratorios de **Ruta Cloud Native** sin instalar nada: cada uno abre un clúster real de Kubernetes en el navegador, guía los pasos y comprueba el resultado.

Son la versión web de los laboratorios locales del curso. El contenido es el mismo, adaptado a un clúster de dos nodos y a sesiones de una hora.

## Escenarios

| Carpeta | Escenario | Duración |
|---|---|---|
| `03-1-pods` | Módulo 03 (1 de 3) · Pods, labels y ReplicaSets | 30 min |
| `03-2-deployments` | Módulo 03 (2 de 3) · Deployments, configuración y Jobs | 40 min |
| `03-3-reto` | Módulo 03 (3 de 3) · Reto | 20 min |

Cada escenario es independiente: empieza con un clúster limpio y no necesita que hayas hecho el anterior.

## Estructura de un escenario

```text
03-1-pods/
  index.json        título, pasos, archivos que se suben y tipo de clúster
  intro.md          pantalla inicial
  setup.sh          se ejecuta en segundo plano al abrir: crea el namespace
  espera.sh         se ejecuta en la terminal: espera a que setup.sh termine
  stepN/text.md     texto del paso
  stepN/verify.sh   comprobación del paso: aprueba si termina con código 0
  finish.md         pantalla final
  assets/           manifiestos que se copian al clúster
```

Convenciones:

- Todo el trabajo va en el namespace `lab-XX` del módulo.
- Los manifiestos se copian a `/root/lab`.
- Cada `verify.sh` comprueba el estado del clúster, no los comandos que se escribieron, e imprime qué falta.
- Los scripts usan saltos de línea LF (lo fuerza `.gitattributes`).

## Publicar en Killercoda

1. Crea una cuenta en Killercoda y, en la sección de creadores, añade este repositorio con la rama `main`.
2. Copia la llave de despliegue que te da Killercoda en *Settings → Deploy keys* del repositorio, con acceso de solo lectura.
3. Añade el webhook que te indica (URL y secreto, contenido JSON) en *Settings → Webhooks*.

A partir de ahí, cada `git push` actualiza los escenarios.

## Aviso

Material de estudio independiente. No está afiliado ni respaldado por la Cloud Native Computing Foundation ni por The Linux Foundation.
