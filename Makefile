# Create the rootfs tarball
# $Ragnarok: Makefile,v 1.1 2024/04/17 14:50:54 lecorbeau Exp $

include config.mk

miniroot:
	/usr/bin/mmdebstrap --variant="${VARIANT}" \
		--components="${COMPONENTS}" \
		--hook-directory=hooks/ \
		"${FLAVOUR}" miniroot${VERSION}.tgz \
		"deb https://ragnarokos.github.io/base/deb/ ${CODENAME} main" \
		"deb http://deb.debian.org/debian/ ${FLAVOUR} main non-free-firmware" \
		"deb http://security.debian.org/ ${FLAVOUR}-security main non-free-firmware" \
		"deb http://deb.debian.org/debian/ ${FLAVOUR}-updates main non-free-firmware"
