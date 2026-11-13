# Laboratorio guiado terminado

Has visto que:

- un **native sidecar** es un init container con `restartPolicy: Always`: arranca antes que la app, cuenta en READY (`2/2`) y vive todo el Pod,
- el sidecar amplía la aplicación sin tocar su código: nginx no sabe que alguien lee sus logs,
- una **HTTPRoute** de Gateway API reparte el tráfico por **pesos** en sus `backendRefs`, con independencia del número de Pods,
- cambiar los pesos reprograma el proxy en caliente, sin reiniciar ningún Pod: la misma idea que usa un service mesh entre su control plane y su data plane.

Queda el reto: **Módulo 07 (2 de 2) · Reto**. Allí construyes sin guía un Pod con sidecar y una HTTPRoute que combina cabeceras y pesos, y el escenario la comprueba.
