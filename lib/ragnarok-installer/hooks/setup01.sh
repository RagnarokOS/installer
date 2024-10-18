#!/bin/sh

# Customize before the setup phase
# $Ragnarok: setup01.sh,v 1.2 2024/10/18 15:30:10 lecorbeau Exp $

set -e

# Create needed directories (NOTE: why is /usr/bin being created?)
mkdir -p "$1"/etc
mkdir -p "$1"/usr/bin

# Copy live ISO's /etc/apt directory
cp -r /etc/apt/ "$1"/etc/

# Creating /etc/mailname. bsd-mailx and dma are installed non-interactively and we need
# this file to prevent dpkg from setting mailname to 'root' when dma is installed.
touch "$1"/etc/mailname
