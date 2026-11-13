Vas a comparar dos Pods con la misma imagen: `pod-root` no tiene `securityContext` y `pod-seguro` está endurecido. Lee los dos manifiestos y créalos:

`cat /root/lab/04-pod-root.yaml /root/lab/05-pod-seguro.yaml`{{exec}}

`kubectl apply -f /root/lab/04-pod-root.yaml -f /root/lab/05-pod-seguro.yaml`{{exec}}

`kubectl wait --for=condition=Ready pod/pod-root pod/pod-seguro -n lab-05 --timeout=90s`{{exec}}

Primero el Pod sin `securityContext`: quién es, si puede escribir y qué capabilities tiene:

`kubectl exec -n lab-05 pod-root -- id`{{exec}}

`kubectl exec -n lab-05 pod-root -- sh -c 'touch /prueba && echo escritura-ok'`{{exec}}

`kubectl exec -n lab-05 pod-root -- grep CapEff /proc/1/status`{{exec}}

```text
uid=0(root) gid=0(root) groups=0(root),10(wheel)
escritura-ok
CapEff:	00000000a80425fb
```

Ahora lo mismo en el Pod endurecido:

`kubectl exec -n lab-05 pod-seguro -- id`{{exec}}

`kubectl exec -n lab-05 pod-seguro -- touch /prueba`{{exec}}

`kubectl exec -n lab-05 pod-seguro -- sh -c 'touch /tmp/prueba && ls -l /tmp/prueba'`{{exec}}

`kubectl exec -n lab-05 pod-seguro -- grep -E 'CapEff|NoNewPrivs' /proc/1/status`{{exec}}

```text
uid=1000 gid=3000 groups=2000,3000
touch: /prueba: Read-only file system
command terminated with exit code 1
-rw-r--r--    1 1000     2000             0 ... /tmp/prueba
NoNewPrivs:	1
CapEff:	0000000000000000
```

**Qué observar**

- Sin `securityContext`, el contenedor corre como root, puede escribir en su sistema de archivos y tiene el conjunto de capabilities por defecto del runtime (`a80425fb`).
- El Pod endurecido corre como UID 1000, con grupo 3000 y grupo suplementario 2000 por `fsGroup`.
- No puede escribir salvo en el `emptyDir` montado en `/tmp`: el archivo nuevo pertenece al grupo 2000 del `fsGroup`.
- Tiene **cero** capabilities y `NoNewPrivs: 1` gracias a `allowPrivilegeEscalation: false`.
- El `securityContext` de nivel Pod aplica a todos los contenedores; el de nivel contenedor tiene prioridad.

Pulsa **CHECK**.
