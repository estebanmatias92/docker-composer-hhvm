#!/bin/bash
set -e

if [ "$1" = 'composer' ]; then
    exec gosu composer "$@"
fi

exec "$@"
