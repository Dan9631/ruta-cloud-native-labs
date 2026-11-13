Intenta ampliar el PVC `datos` de 100Mi a 200Mi cambiando el tamaño pedido:

`kubectl patch pvc datos -n lab-08 --type=json -p '[{"op":"replace","path":"/spec/resources/requests/storage","value":"200Mi"}]'`{{exec}}

```text
Error from server (Forbidden): persistentvolumeclaims "datos" is forbidden: only dynamically provisioned pvc can be resized and the storageclass that provisions the pvc must support resize
```

Comprueba qué dice la clase:

`kubectl get sc standard -o jsonpath='{.allowVolumeExpansion}'; echo`{{exec}}

La salida está vacía: el campo no está puesto, y sin él vale `false`.

**Qué observar**

- La expansión necesita `allowVolumeExpansion: true` en la StorageClass y un driver que la soporte. local-path no la soporta.
- Aunque estuviera permitida, un PVC solo se puede **ampliar**, nunca reducir.
- Con un patch de tipo `json` (`--type=json`) cambias un único campo indicando su ruta.

Este paso no tiene comprobación. Pulsa **NEXT** para terminar.
