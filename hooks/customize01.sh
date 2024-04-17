#!/bin/ksh

# Commands to configure miniroot.
# $Ragnarok: customize01.sh,v 1.1 2024/04/17 15:09:58 lecorbeau Exp $

set -e

# Enable the wheel group.
sed -i '15 s/^# //' "$1"/etc/pam.d/su
chroot "$1" addgroup --system wheel

# Make sure ksh is the default shell for root.
sed -i 's/bash/ksh/g' "$1"/etc/passwd
