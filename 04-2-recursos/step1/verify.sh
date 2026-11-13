#!/bin/bash
# Los tres Pods de 10-qos.yaml existen, Running, con su QoS class.
ns=lab-04
for par in qos-guaranteed:Guaranteed qos-burstable:Burstable qos-besteffort:BestEffort; do
  pod=${par%%:*}; qos=${par##*:}
  estado=$(kubectl get pod $pod -n $ns -o jsonpath='{.status.phase}/{.status.qosClass}' 2>/dev/null)
  [ "$estado" = "Running/$qos" ] || { echo "Falta el Pod $pod Running con QoS $qos (ahora: '$estado'). Aplica 10-qos.yaml"; exit 1; }
done
