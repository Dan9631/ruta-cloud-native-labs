echo "Preparando el laboratorio..."
while [ ! -f /tmp/listo ]; do sleep 1; done
clear
echo "Listo: namespace lab-05 creado con el perfil restricted de Pod Security Admission"
kubectl get nodes
