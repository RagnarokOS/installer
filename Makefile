# Create the rootfs tarball
# $Ragnarok: Makefile,v 1.4 2024/08/24 15:21:18 lecorbeau Exp $

all: pkg

# Create the installer pkg
pkg:
	cd installer; \
		equivs-build ragnarok-installer.pkg 2>&1 | tee ragnarok-installer.build
