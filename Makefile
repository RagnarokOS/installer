# Build ragnarok-install package
# $Ragnarok: Makefile,v 1.8 2024/09/20 17:10:32 lecorbeau Exp $

PKG	= ragnarok-installer
VERSION	= 01
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
