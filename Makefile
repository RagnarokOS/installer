# Build ragnarok-install package
# $Ragnarok: Makefile,v 1.7 2024/09/19 19:30:21 lecorbeau Exp $

PKG	= ragnarok-installer
VERSION	= 01
DESTDIR	= ${PKG}_${VERSION}

all: 
	mkdir -p ${DESTDIR}
	cp -r DEBIAN/ ${DESTDIR}
	cp -r lib/ usr/ ${DESTDIR}
	rm ${DESTDIR}/lib/ragnarok-installer/.gitignore
	rm ${DESTDIR}/usr/bin/.gitignore

# Create the installer pkg
pkg:
	dpkg-deb -b ${DESTDIR}
