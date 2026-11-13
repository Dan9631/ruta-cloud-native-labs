Con el chart `/root/lab/helm/saludo`, en el namespace `lab-12`:

1. Instala un release llamado **`tienda`** con el mensaje `Tienda v1`, **sin editar** `values.yaml`.
2. Haz un upgrade a **3 réplicas** conservando el mensaje.
3. Vuelve a la **revisión 1** con un rollback.

**Pistas**

- `helm install --help`{{copy}} y `helm upgrade --help`{{copy}}: busca `--set` y `--reuse-values`.
- Comprueba lo que se pasó en cada revisión con `helm get values tienda -n lab-12 --revision N`.
- `helm history tienda -n lab-12` te dice en qué revisión estás.

Cuando creas que está, pulsa **CHECK**.

**Si te atascas**

La solución está en el mismo archivo que la del paso anterior:

`cat /root/solucion/pasos.txt`{{copy}}
