# Kustomize: una base, dos entornos

Este escenario es la primera parte del laboratorio del módulo 12 de **Ruta Cloud Native** (entrega de aplicaciones y GitOps). Trabajas en un clúster real de Kubernetes con dos nodos: `controlplane` y `node01`.

En unos 25 minutos vas a:

- ver qué genera un overlay de Kustomize sin aplicarlo,
- desplegar dos entornos (dev y prod) a partir de la misma base,
- comprobar que los Services de cada entorno no se mezclan,
- provocar un cambio a mano y detectarlo con `kubectl diff`, como haría un agente GitOps.

Todo se hace en el namespace `lab-12`, que se crea solo al arrancar. Los archivos están en `/root/lab/kustomize`:

```text
kustomize/
  base/              deployment.yaml, service.yaml, kustomization.yaml
  overlays/dev/      kustomization.yaml
  overlays/prod/     kustomization.yaml, recursos-patch.yaml
```

Kustomize viene integrado en `kubectl` (`kubectl kustomize`, `kubectl apply -k`): no hay que instalar nada.

Cómo usarlo:

- Haz clic en un comando para ejecutarlo en la terminal.
- Al final de cada paso pulsa **CHECK**: el escenario comprueba el estado del clúster antes de dejarte avanzar.
- La sesión dura como máximo una hora y el clúster se borra al terminar.

Espera a que la terminal muestre los dos nodos y pulsa **START**.
