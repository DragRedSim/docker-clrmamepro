#!/usr/bin/env sh
#shellcheck shell=sh

set -xe

HOME=/config
export HOME

cd /opt/clrmamepro

# Allow running of native linux binaries
/usr/lib/wine/wine64 regedit /C /run_native_applications.reg

# Launch clrmamepro
/usr/lib/wine/wine64 /opt/clrmamepro/cmpro64.exe 2>&1 | awk -W Interactive '{print "[clrmamepro] " $0}'
