#!/bin/sh

# $Ragnarok: customize03.sh,v 1.1 2024/08/20 17:24:52 lecorbeau Exp $

msg "Cleaning up..."
rm "$1"/etc/resolv.conf
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
	if [ -f "$1"/"${_file}" ]; then
		rm "$1"/"${_file}"
	fi
done
