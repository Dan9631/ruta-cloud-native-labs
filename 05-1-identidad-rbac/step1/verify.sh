#!/bin/bash
# /root/admin.crt es un certificado X.509 valido con un CN (el usuario del kubeconfig).
[ -s /root/admin.crt ] || { echo "Falta /root/admin.crt: extrae el certificado de cliente del kubeconfig"; exit 1; }
sujeto=$(openssl x509 -in /root/admin.crt -noout -subject 2>/dev/null)
echo "$sujeto" | grep -q 'CN' || { echo "/root/admin.crt no es un certificado valido: repite el comando con base64 -d"; exit 1; }
