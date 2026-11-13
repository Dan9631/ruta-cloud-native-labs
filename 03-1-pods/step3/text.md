Borra el Pod del paso anterior, que ya no hace falta:

`kubectl delete pod nginx -n lab-03`{{exec}}

Lee el manifiesto del nuevo Pod. Tiene un init container, un contenedor nginx y un sidecar, y los tres comparten un volumen `emptyDir`:

`cat /root/lab/pod-multi.yaml`{{exec}}

Aplícalo y míralo enseguida:

`kubectl apply -f /root/lab/pod-multi.yaml`{{exec}}

`kubectl get pod multi -n lab-03`{{exec}}

```text
NAME    READY   STATUS     RESTARTS   AGE
multi   0/2     Init:0/1   0          7s
```

Espera a que esté listo y vuelve a mirar:

`kubectl wait --for=condition=Ready pod/multi -n lab-03 --timeout=90s`{{exec}}

`kubectl get pod multi -n lab-03`{{exec}}

Mira qué recibe el sidecar y pide tú la página desde dentro de él:

`kubectl logs multi -c sidecar -n lab-03 --tail=3`{{exec}}

`kubectl exec multi -c sidecar -n lab-03 -- wget -qO- http://localhost/`{{exec}}

```text
<h1>Pagina creada por el init container</h1>
```

**Qué observar**

- `Init:0/1` mientras corre el init container; después `2/2`, porque hay dos contenedores principales.
- El sidecar llega a nginx por **localhost**: los contenedores de un Pod comparten la red.
- nginx sirve el archivo que escribió el init container en el volumen compartido.
- Si en el log completo (`kubectl logs multi -c sidecar -n lab-03`) aparece un `Connection refused` al principio, es porque los contenedores principales **arrancan a la vez, sin orden**: el sidecar preguntó antes de que nginx estuviera listo.

Pulsa **CHECK**.
