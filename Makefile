# Build ragnarok-install package
# $Ragnarok: Makefile,v 1.14 2024/10/20 15:20:30 lecorbeau Exp $

PKG	= ragnarok-installer
VERSION	= 01-4
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
