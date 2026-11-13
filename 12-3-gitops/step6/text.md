Esta es la parte GitOps del reto del módulo. Solo mediante **commits** al repo `git://localhost/app.git` (nada de `kubectl scale` ni `kubectl apply` sobre la app):

1. Deja `gitops-web` con **3 réplicas**.
2. Añade al repo un ConfigMap llamado **`gitops-config`** con la clave `entorno: lab`, y que sea Argo CD quien lo cree en `lab-12`.

**Pistas**

- Trabaja en tu clon, `/root/app`. Con `nano` o `vim` editas y creas archivos; `git add`, `git commit` y `git push` hacen el resto.
- Un archivo nuevo no entra en el commit hasta que lo añades con `git add`.
- El manifiesto del ConfigMap no necesita `namespace`: la Application lo despliega en `lab-12`.
- Si `git push` no conecta, el port-forward se ha cortado. Vuelve a lanzarlo:

`pkill -f 'port-forward -n lab-12 svc/git-server'; kubectl port-forward -n lab-12 svc/git-server 9418:9418 > /tmp/pf-git.log 2>&1 &`{{exec}}

- Después del push, fuerza el refresh como en el paso anterior.

Si intentas hacer trampa con `kubectl scale --replicas=3`, el selfHeal lo devuelve a 2: el único camino es Git.

Cuando creas que está, pulsa **CHECK**.

**Si te atascas**

Hay una solución en `/root/solucion`. Inténtalo antes de mirarla:

`cat /root/solucion/pasos.txt`{{copy}}
