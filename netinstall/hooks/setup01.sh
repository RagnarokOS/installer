#!/bin/sh

# $Ragnarok: setup01.sh,v 1.1 2024/08/19 15:15:30 lecorbeau Exp $

set -e

# Copy needed files from the ISO.
mkdir -p "$1"/etc
mkdir -p "$1"/usr/bin
cp -r /etc/apt/ "$1"/etc/

# Creating /etc/mailname. bsd-mailx and dma are installed non-interactively and we need
# this file to prevent dpkg from setting mailname to 'root' when dma is installed.
touch "$1"/etc/mailname
