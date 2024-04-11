#!/bin/sh

# Customize before the setup phase
# $Ragnarok: setup01.sh,v 1.2 2024/04/11 14:34:21 lecorbeau Exp $

set -e

# Copy apt sources and keys to the chroot
mkdir -p "$1"/etc/apt
cp -r ../src/etc/apt/sources.list.d "$1"/etc/apt/
cp -r ../src/etc/apt/trusted.gpg.d/ "$1"/etc/apt/

# Set the default debconf frontend to Readline
chroot "$1" echo 'debconf debconf/frontend select Readline' | debconf-set-selections

# Creating /etc/mailname. bsd-mailx and dma are installed non-interactively and we need
# this file to prevent dpkg from setting mailname to 'root' when dma is installed.
touch "$1"/etc/mailname
