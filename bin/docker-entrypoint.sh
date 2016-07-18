#!/bin/bash

set -e
PILOT="/bin/amp-pilot"

# Add elasticsearch as command if needed
if [ "${1:0:1}" = '-' ]; then
    set -- elasticsearch "$@"
fi
program="$1"

if [[ -n "$CONSUL" && -n "$PILOT" && "$program" = "elasticsearch" ]]; then
    export AMPPILOT_LAUNCH_CMD="$@"
    echo "registering in Consul with $PILOT"
    set -- "$PILOT" "$@"
else
    echo "not registering in Consul"
fi

# Drop root privileges if we are running elasticsearch
# allow the container to be started with `--user`
if [[ "$program" = "elasticsearch" && "$(id -u)" = '0' ]]; then
    # Change the ownership of /var/lib/elasticsearch/data to elasticsearch
    chown -R elastico:elastico /var/lib/elasticsearch/data
    
    set -- gosu elastico "$@"
fi

exec "$@"
