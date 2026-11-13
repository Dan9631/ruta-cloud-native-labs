Pregunta si la ServiceAccount `lector` puede listar Pods. Todavía no existe y no tiene permisos:

`kubectl auth can-i list pods -n lab-05 --as=system:serviceaccount:lab-05:lector`{{exec}}

```text
no
```

Lee el manifiesto: una ServiceAccount, un Role con permisos de lectura sobre Pods y sus logs, y un RoleBinding que une los dos. Aplícalo:

`cat /root/lab/01-sa-lector.yaml`{{exec}}

`kubectl apply -f /root/lab/01-sa-lector.yaml`{{exec}}

Vuelve a preguntar, ahora con varios verbos, recursos y namespaces:

`kubectl auth can-i list pods -n lab-05 --as=system:serviceaccount:lab-05:lector`{{exec}}

`kubectl auth can-i get pods --subresource=log -n lab-05 --as=system:serviceaccount:lab-05:lector`{{exec}}

`kubectl auth can-i delete pods -n lab-05 --as=system:serviceaccount:lab-05:lector`{{exec}}

`kubectl auth can-i list pods -n default --as=system:serviceaccount:lab-05:lector`{{exec}}

`kubectl auth can-i get secrets -n lab-05 --as=system:serviceaccount:lab-05:lector`{{exec}}

```text
yes
yes
no
no
no
```

Pide la lista completa de lo que puede hacer y prueba a leer Secrets en su nombre:

`kubectl auth can-i --list -n lab-05 --as=system:serviceaccount:lab-05:lector`{{exec}}

`kubectl get secrets -n lab-05 --as=system:serviceaccount:lab-05:lector`{{exec}}

```text
Resources                                       Non-Resource URLs   Resource Names   Verbs
selfsubjectreviews.authentication.k8s.io        []                  []               [create]
selfsubjectaccessreviews.authorization.k8s.io   []                  []               [create]
selfsubjectrulesreviews.authorization.k8s.io    []                  []               [create]
pods/log                                        []                  []               [get list watch]
pods                                            []                  []               [get list watch]
...
Error from server (Forbidden): secrets is forbidden: User "system:serviceaccount:lab-05:lector" cannot list resource "secrets" in API group "" in the namespace "lab-05"
```

**Qué observar**

- Los permisos son exactamente los del Role y solo en `lab-05`: en `default` la respuesta es «no».
- El mensaje `Forbidden` (403) dice el usuario, el verbo, el recurso, el grupo y el namespace. Así sabes qué regla falta.
- Los permisos `selfsubject...` y las URLs como `/healthz` o `/version` los tiene cualquier usuario autenticado.

Pulsa **CHECK**.
