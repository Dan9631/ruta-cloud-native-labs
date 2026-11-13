Crea un overlay nuevo, `/root/lab/kustomize/overlays/qa`, que reutilice la base y genere en `lab-12`:

1. Un Deployment llamado `qa-web` con **2 réplicas** y la imagen **`nginx:1.28-alpine`**.
2. La etiqueta `env=qa` en los Pods **y** en el selector del Service `qa-web`.

No modifiques la base.

**Pistas**

- Copia la idea de los overlays que ya tienes: `cat /root/lab/kustomize/overlays/prod/kustomization.yaml`{{copy}}
- Antes de aplicar, renderiza con `kubectl kustomize` y comprueba nombres, réplicas, imagen y selectores.
- En `replicas:` e `images:` se usa el nombre que tienen el Deployment y la imagen **en la base**, no el nombre final con prefijo.

Cuando creas que está, pulsa **CHECK**.

**Si te atascas**

Hay una solución completa en `/root/solucion`. Inténtalo antes de mirarla:

`cat /root/solucion/pasos.txt`{{copy}}
