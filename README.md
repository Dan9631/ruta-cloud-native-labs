# Ruta Cloud Native · laboratorios en el navegador

Escenarios de [Killercoda](https://killercoda.com) para hacer los laboratorios de **Ruta Cloud Native** sin instalar nada: cada uno abre un clúster real de Kubernetes en el navegador, guía los pasos y comprueba el resultado.

Son la versión web de los laboratorios locales del curso. El contenido es el mismo, adaptado a un clúster de dos nodos y a sesiones de una hora. Las duraciones son estimadas.

## Escenarios

| Carpeta | Escenario | Duración |
|---|---|---|
| `01-1-contenedores` | Módulo 01 (1 de 4) · Contenedores con Podman | 25 min |
| `01-2-imagenes` | Módulo 01 (2 de 4) · Construir imágenes y usar un registry | 30 min |
| `01-3-kubernetes` | Módulo 01 (3 de 4) · Tu imagen en Kubernetes | 30 min |
| `01-4-reto` | Módulo 01 (4 de 4) · Reto | 20 min |
| `02-1-componentes` | Módulo 02 (1 de 3) · Componentes del clúster | 30 min |
| `02-2-controladores` | Módulo 02 (2 de 3) · Controladores, API y kubeconfig | 30 min |
| `02-3-reto` | Módulo 02 (3 de 3) · Reto | 20 min |
| `03-1-pods` | Módulo 03 (1 de 3) · Pods, labels y ReplicaSets | 30 min |
| `03-2-deployments` | Módulo 03 (2 de 3) · Deployments, configuración y Jobs | 40 min |
| `03-3-reto` | Módulo 03 (3 de 3) · Reto | 20 min |
| `04-1-colocacion` | Módulo 04 (1 de 3) · Dónde cae cada Pod: selectors, afinidad y taints | 35 min |
| `04-2-recursos` | Módulo 04 (2 de 3) · Recursos, DaemonSets y prioridad | 40 min |
| `04-3-reto` | Módulo 04 (3 de 3) · Reto | 20 min |
| `05-1-identidad-rbac` | Módulo 05 (1 de 3) · Identidad, RBAC y ServiceAccounts | 35 min |
| `05-2-pods-seguros-red` | Módulo 05 (2 de 3) · securityContext, Pod Security y NetworkPolicies | 40 min |
| `05-3-reto` | Módulo 05 (3 de 3) · Reto | 25 min |
| `06-1-services` | Módulo 06 (1 de 3) · Services y DNS | 35 min |
| `06-2-ingress-gateway` | Módulo 06 (2 de 3) · Ingress y Gateway API con Traefik | 25 min |
| `06-3-reto` | Módulo 06 (3 de 3) · Reto | 20 min |
| `07-1-sidecar-canary` | Módulo 07 (1 de 2) · Sidecars y canary con Gateway API | 40 min |
| `07-2-reto` | Módulo 07 (2 de 2) · Reto | 25 min |
| `08-1-volumenes-pvc` | Módulo 08 (1 de 3) · Volúmenes, PVC y aprovisionamiento dinámico | 35 min |
| `08-2-pv-statefulset` | Módulo 08 (2 de 3) · PV estático, StatefulSets y volúmenes projected | 40 min |
| `08-3-reto` | Módulo 08 (3 de 3) · Reto | 20 min |
| `09-1-diagnostico` | Módulo 09 (1 de 3) · Diagnóstico: get, describe, eventos y logs | 30 min |
| `09-2-herramientas` | Módulo 09 (2 de 3) · kubectl debug, top y salud del clúster | 35 min |
| `09-3-reto` | Módulo 09 (3 de 3) · Reto | 40 min |
| `10-1-hpa` | Módulo 10 (1 de 2) · Autoscaling con HPA | 35 min |
| `10-2-reto` | Módulo 10 (2 de 2) · Reto | 20 min |
| `11-1-prometheus` | Módulo 11 (1 de 3) · Logs, kubectl top e instalar Prometheus | 40 min |
| `11-2-promql` | Módulo 11 (2 de 3) · Consultas PromQL | 30 min |
| `11-3-reto` | Módulo 11 (3 de 3) · Reto | 25 min |
| `12-1-kustomize` | Módulo 12 (1 de 4) · Kustomize: una base, dos entornos | 25 min |
| `12-2-helm` | Módulo 12 (2 de 4) · Helm: chart propio, upgrade y rollback | 30 min |
| `12-3-gitops` | Módulo 12 (3 de 4) · GitOps con Argo CD | 45 min |
| `12-4-reto` | Módulo 12 (4 de 4) · Reto | 25 min |

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
