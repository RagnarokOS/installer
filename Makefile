# Build ragnarok-install package
# $Ragnarok: Makefile,v 1.11 2024/10/03 15:35:21 lecorbeau Exp $

PKG	= ragnarok-installer
VERSION	= 01-3
DESTDIR	= ${PKG}_${VERSION}

all: 
	mkdir -p ${DESTDIR}
	cp -r DEBIAN/ ${DESTDIR}
	cp -r lib/ usr/ ${DESTDIR}
	rm ${DESTDIR}/lib/ragnarok-installer/.gitignore
	rm ${DESTDIR}/usr/bin/.gitignore
	rm -r ${DESTDIR}/usr/share/ragnarok-installer/hooks

# Create the installer pkg
pkg:
	dpkg-deb -b ${DESTDIR}
