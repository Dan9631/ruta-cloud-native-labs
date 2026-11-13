#!/bin/bash
# Hay un Pod de depuracion de nodo (node-debugger-node01-...) en lab-09, programado en node01.
pods=$(kubectl get pods -n lab-09 -o jsonpath='{range .items[*]}{.metadata.name} {.spec.nodeName}{"\n"}{end}' 2>/dev/null | grep '^node-debugger-node01-')
[ -n "$pods" ] || { echo "Falta el Pod de depuracion de nodo en lab-09: ejecuta kubectl debug node/node01 -n lab-09 ..."; exit 1; }
echo "$pods" | grep -q ' node01$' || { echo "El Pod de depuracion no esta en node01"; exit 1; }
