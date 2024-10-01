# Build ragnarok-install package
# $Ragnarok: Makefile,v 1.10 2024/10/01 19:36:11 lecorbeau Exp $

PKG	= ragnarok-installer
VERSION	= 01-2
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
