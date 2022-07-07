#!/bin/sh
set -eux

LAST_LOG="$(find "$LOGS_LOC" | tail -n 1)"

if [ $(grep -c "connected to Steam" "$LAST_LOG") = 0 ]; then
    exit 0
else
    exit 1
fi
