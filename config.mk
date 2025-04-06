# $Ragnarok: config.mk,v 1.1 2025/04/06 23:31:28 lecorbeau Exp $
# Config file for a Ragnarok install. Adjust to fit your system.

## Ragnarok version
VERSION		= 02

## Where should the system be installed. Default: /mnt/ragnarok
TARGET		= /mnt/ragnarok

## Disk Configuration
DEVICE		=
# Can be either 'efi' or 'bios'
BOOTMODE	=
# BOOTPART and BOOTSIZE only for 'efi' bootmode
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
