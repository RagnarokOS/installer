# Build ragnarok-install package
# $Ragnarok: Makefile,v 1.17 2024/10/31 17:34:18 lecorbeau Exp $

PKG	= ragnarok-installer
VERSION	= 01-7
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
