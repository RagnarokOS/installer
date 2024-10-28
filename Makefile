# Build ragnarok-install package
# $Ragnarok: Makefile,v 1.16 2024/10/28 15:17:35 lecorbeau Exp $

PKG	= ragnarok-installer
VERSION	= 01-6
DESTDIR	= ${PKG}_${VERSION}

all: 
	mkdir -p ${DESTDIR}
	cp -r DEBIAN/ ${DESTDIR}
	cp -r lib/ usr/ ${DESTDIR}
	rm ${DESTDIR}/lib/ragnarok-installer/.gitignore
	rm ${DESTDIR}/lib/ragnarok-installer/hooks/.gitignore
	rm ${DESTDIR}/usr/bin/.gitignore

# Create the installer pkg
pkg:
	dpkg-deb -b ${DESTDIR}
