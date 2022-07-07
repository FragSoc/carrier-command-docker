#!/bin/sh
set -eux

xvfb-run -a wine "$INSTALL_LOC/dedicated_server.exe" "$@" \
    | tee "$LOG_LOC/$(date +%Y-%m-%d-%H:%M:%S).log"
