#!/bin/bash
# Algun Pod de frontend tiene un contenedor efimero.
efimeros=$(kubectl get pods -n lab-09 -l app=frontend -o jsonpath='{.items[*].spec.ephemeralContainers[*].name}' 2>/dev/null)
[ -n "$efimeros" ] || { echo "Ningun Pod de frontend tiene contenedores efimeros: ejecuta el kubectl debug con --target=nginx"; exit 1; }
