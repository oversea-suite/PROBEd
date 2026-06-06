#!/bin/sh
set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC="$SCRIPT_DIR/.."

install -Dm755 "$SRC/probed"         /usr/bin/probed
install -Dm755 "$SRC/getinfo.sh"     /var/lib/probed/getinfo.sh
install -Dm644 "$SRC/probed.service" /etc/systemd/system/probed.service
if [ ! -f /etc/probed.conf ]; then
    install -Dm644 "$SRC/probed.conf" /etc/probed.conf
fi
systemctl daemon-reload
echo "PROBEd installed. Run: systemctl enable --now probed"
