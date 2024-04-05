#!/bin/sh

set -e

# Clean up the chroot
# $Ragnarok: customize02.sh,v 1.2 2024/04/05 16:28:34 lecorbeau Exp $

printf '%s\n' "Cleaning up the chroot..."
chroot "$1" apt clean
rm -rf "$1"/var/lib/apt/lists/*
rm "$1"/var/log/apt/eipp.log.xz
rm "$1"/var/log/apt/history.log
rm "$1"/var/log/apt/term.log
rm "$1"/var/log/alternatives.log
rm "$1"/var/log/dpkg.log
rm "$1"/etc/resolv.conf
rm "$1"/tmp/*
for _file in /etc/machine-id /var/lib/dbus/machine-id; do
	if [ -f "${1}/${_file}" ]; then
		rm "${1}/${_file}"
	fi
done
