#!/bin/sh
#shellcheck shell=sh

set -e # Exit immediately if a command exits with a non-zero status.
set -u # Treat unset variables as an error.

chown -R $USER_ID:$GROUP_ID /opt/clrmamepro
chown -R $USER_ID:$GROUP_ID /config/clrmamepro
