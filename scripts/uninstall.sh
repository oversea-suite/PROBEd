#!/bin/sh
set -e
systemctl stop probed 2>/dev/null || true
systemctl disable probed 2>/dev/null || true
rm -f /usr/bin/probed
rm -f /var/lib/probed/getinfo.sh
rmdir /var/lib/probed 2>/dev/null || true
rm -f /etc/systemd/system/probed.service
systemctl daemon-reload
echo "PROBEd uninstalled. /etc/probed.conf preserved."
