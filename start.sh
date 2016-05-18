#!/bin/bash

echo "CONSUL: "$CONSUL
if [ -z "$CONSUL" ]; then
  elasticsearch
else
  #update containerpilot conffile
  sed -i "s/\[consul\]/$CONSUL/g" /etc/containerpilot.json
  sed -i "s/\[loglevel\]/$CP_LOG_LEVEL/g" /etc/containerpilot.json  
  echo ---------------------------------------------------------------------------
  echo containerPilot conffile
  cat /etc/containerpilot.json
  echo ---------------------------------------------------------------------------
  /bin/containerpilot elasticsearch
fi
