#!/bin/bash

# Add elasticsearch as command if needed
if [ "${1:0:1}" = '-' ]; then
    echo "INFO - adding arguments $@ to elasticsearch"
    set -- elasticsearch "$@"
fi
program="$1"

if [[ -z "$JAVA_HEAP_SIZE" ]]; then
  # adjust max heap size to available memory
  if [[ -f /proc/meminfo ]]; then
    tmem=$(grep MemTotal /proc/meminfo | awk '{print int($2 * 0.001)}')
    echo "INFO - system memory is ${tmem}M"
    if [[ $tmem -lt 1024 ]]; then
        echo "INFO - set java heap size to floor value"
        JAVA_HEAP_SIZE=256
    elif [[ $tmem -lt 4092 ]]; then
        echo "INFO - set java heap size to ramping value"
        # 256 to 410
        JAVA_HEAP_SIZE=$((256 + (tmem - 1024) / 19))
    else
        echo "INFO - set java heap size to 10%"
        JAVA_HEAP_SIZE=$((tmem / 10))
    fi
    export JAVA_HEAP_SIZE
  else
    echo "WARN - can't read /proc/meminfo, using default java heap size value"
  fi
fi

runes=0
# Drop root privileges if we are running elasticsearch
# allow the container to be started with `--user`
if [[ "x$program" = "xelasticsearch" ]]; then runes=1; fi

if [[ $runes -eq 1 && "$(id -u)" = '0' ]]; then
    echo "INFO - setting user perms on elasticsearch data dir"
    # Change the ownership of /var/lib/elasticsearch/data to elasticsearch
    chown -R elastico:elastico /var/lib/elasticsearch/data
    
    echo "INFO - running $1 as user elastico"
    set -- gosu elastico "$@"
fi

echo "INFO - running $@"
exec "$@"
