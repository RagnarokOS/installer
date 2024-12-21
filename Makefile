# Build ragnarok-install package
# $Ragnarok: Makefile,v 1.18 2024/12/21 16:48:06 lecorbeau Exp $

PKG	= ragnarok-installer
VERSION	= 02~rc1
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
