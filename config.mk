# $Ragnarok: config.mk,v 1.2 2025/04/07 16:59:05 lecorbeau Exp $
# Config file for a Ragnarok install. Adjust to fit your system.

## Ragnarok version.
VERSION		= 02

## The stage 3 tarball to use.
STAGE3		= base${VERSION}.tgz

## Where should the system be installed. Default: /mnt/ragnarok.
TARGET		= /mnt/ragnarok

## Disk Configuration

# Which disk should the system be installed on, eg. /dev/sda.
DEVICE		=

# Can be either 'efi-64' for efi boot, or 'pc' for legacy bios.
BOOTMODE	=

# Boot partition and its size
BOOTPART	=
BOOTSIZE	=

# Swap partition and its size
SWAPPART	=
SWAPSIZE	=

# Root partition and its size
ROOTPART	=
ROOTSIZE	=

# home partition and its size
HOMEPART	=
HOMESIZE	=

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
