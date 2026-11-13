#!/bin/bash
# El repositorio prometheus-community esta anadido en helm y el chart 29.37.2 se encuentra.
helm repo list 2>/dev/null | grep -q '^prometheus-community' \
  || { echo "Falta anadir el repositorio de Helm prometheus-community"; exit 1; }
helm search repo prometheus-community/prometheus --version 29.37.2 2>/dev/null | grep -q '29.37.2' \
  || { echo "Helm no encuentra el chart prometheus-community/prometheus 29.37.2: ejecuta helm repo update prometheus-community"; exit 1; }
