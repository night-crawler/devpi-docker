#!/usr/bin/env bash

set -e

function initialise_devpi {
    echo "[RUN]: Initialise devpi-server"
    devpi-server --restrict-modify root --start --init --host 127.0.0.1 --port 3141
    devpi-server --status
    devpi use http://localhost:3141
    devpi login root --password=''
    devpi user -m root password="${DEVPI_PASSWORD}"
    devpi index -y -c public pypi_whitelist='*'
    devpi-server --stop
    devpi-server --status
}

if [ "$1" = 'devpi' ]; then
    if [ ! -f  "${DEVPI_SERVERDIR}/.serverversion" ]; then
        initialise_devpi
    fi

    echo "[RUN]: Launching devpi-server"
    exec devpi-server \
        --restrict-modify root \
        --host 0.0.0.0 \
        --port 3141 \
        --logger-cfg=${DEVPI_LOGGER_CFG} \
        --mirror-cache-expiry=${DEVPI_MIRROR_CACHE_EXPIRY}
fi

echo "[RUN]: Builtin command not provided [devpi]"
echo "[RUN]: $@"

exec "$@"

#
#if [ ! -f "${DEVPI_SERVERDIR}/.serverversion" ]; then
#  devpi-server --init
#
#  if [ -n "${DEVPI_PASSWORD}" ]; then
#    devpi-server --restrict-modify root --start --host 127.0.0.1 --port 3142
#    devpi-server --status
#    devpi use http://127.0.0.1:3142
#    devpi login root --password=''
#    devpi user -m root password="${DEVPI_PASSWORD}"
#    devpi index -y -c public pypi_whitelist='*'
#    devpi-server --stop
#  fi
#fi
#
#devpi-server \
#  --logger-cfg=/logger_cfg.json \
#  --restrict-modify root \
#  --mirror-cache-expiry=${DEVPI_MIRROR_CACHE_EXPIRY} \
#  --host 0.0.0.0 \
#  --port 3141
