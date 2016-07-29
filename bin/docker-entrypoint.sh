#!/bin/bash

# Add elasticsearch as command if needed
if [ "${1:0:1}" = '-' ]; then
    echo "INFO - adding arguments $@ to elasticsearch"
    set -- elasticsearch "$@"
fi
program="$1"

runes=0
# Drop root privileges if we are running elasticsearch
# allow the container to be started with `--user`
echo "$program" | grep -q amppilot
if [[ $? -eq 0 ]]; then runes=1; fi
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
