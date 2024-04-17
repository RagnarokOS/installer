# Config file
# $Ragnarok: config.mk,v 1.2 2024/04/17 15:02:39 lecorbeau Exp $

VERSION		= 01
CODENAME	= current
FLAVOUR		= bookworm
VARIANT		= minbase
COMPONENTS	= main non-free-firmware

# Extra packages that should be installed in the miniroot
PACKAGES	= policy-rcd-declarative-deny-all oksh signify-openbsd \
		  ca-certificates
