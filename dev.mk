# $Ragnarok: dev.mk,v 1.1 2025/04/08 16:26:38 lecorbeau Exp $
# Disk Configuration

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

# home partition and its size. Leave HOMESIZE empty to use all remaining
# disk space.
HOMEPART	=
HOMESIZE	=


