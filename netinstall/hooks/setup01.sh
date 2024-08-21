#!/bin/sh

# $Ragnarok: setup01.sh,v 1.2 2024/08/21 18:06:38 lecorbeau Exp $

set -e

cp /install.conf "$1"/

# Copy needed files from the ISO.
mkdir -p "$1"/etc
mkdir -p "$1"/usr/bin
cp -r /etc/apt/ "$1"/etc/

# Creating /etc/mailname. bsd-mailx and dma are installed non-interactively and we need
# this file to prevent dpkg from setting mailname to 'root' when dma is installed.
touch "$1"/etc/mailname
