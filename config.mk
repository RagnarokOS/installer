# $Ragnarok: config.mk,v 1.4 2025/04/10 19:58:33 lecorbeau Exp $
# Config file for a Ragnarok install. Adjust to fit your system.

## Ragnarok version.
VERSION		= 02

## The stage 3 tarball to use.
STAGE3		= base${VERSION}.tgz

## The sig key to use with signify (to verify file integrity).
SIGKEY		= /etc/signify/ragnarok${VERSION}.pub

## Where should the system be installed. Default: /mnt/ragnarok.
TARGET		= /mnt/ragnarok

## By default, Ragnarok uses separate /boot, swap, / and /home partitions.
## If you wish to create your own partitioning scheme (or use disk encryption),
## then comment out the line below.
MAKE_DEV	= yes

## System Config
HOSTNAME	=
LOCALE		=
TIMEZONE	=
KEYMAP		=
USERNAME	=

## Other Options.

# How many cores should be used to compile 'third party packages', eg. -j4.
MAKEOPTS	=

# Graphics driver to be used
VIDEOS_CARDS	=
