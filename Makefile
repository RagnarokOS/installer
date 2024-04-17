# Create the rootfs tarball
# $Ragnarok: Makefile,v 1.3 2024/04/17 15:52:15 lecorbeau Exp $

include config.mk

all: miniroot installer

miniroot:
	/usr/bin/mmdebstrap --variant="${VARIANT}" \
		--components="${COMPONENTS}" \
		--include="${PACKAGES}" \
		--hook-directory=hooks/ \
		"${FLAVOUR}" miniroot${VERSION}.tgz \
		"deb https://ragnarokos.github.io/base/deb/ ${CODENAME} main" \
		"deb http://deb.debian.org/debian/ ${FLAVOUR} main non-free-firmware" \
		"deb http://security.debian.org/ ${FLAVOUR}-security main non-free-firmware" \
		"deb http://deb.debian.org/debian/ ${FLAVOUR}-updates main non-free-firmware"

# Create the installer pkg
installer:
	cd installer; \
		equivs-build ragnarok-installer.pkg 2>&1 | tee ragnarok-installer.build
