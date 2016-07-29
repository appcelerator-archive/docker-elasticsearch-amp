#!/bin/bash

set -e
PILOT="/bin/amp-pilot"

# Add elasticsearch as command if needed
if [ "${1:0:1}" = '-' ]; then
    set -- elasticsearch "$@"
fi
program="$1"

# Drop root privileges if we are running elasticsearch
# allow the container to be started with `--user`
if [[ "$program" = "elasticsearch" && "$(id -u)" = '0' ]]; then
    # Change the ownership of /var/lib/elasticsearch/data to elasticsearch
    chown -R elastico:elastico /var/lib/elasticsearch/data
    
    set -- gosu elastico "$@"
fi

exec "$@"
