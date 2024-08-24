# Build ragnarok-install package
# $Ragnarok: Makefile,v 1.5 2024/08/24 17:37:59 lecorbeau Exp $

PKG	= ragnarok-installer
VERSION	= 01
DESTDIR	= ${PKG}_${VERSION}

all: 
	mkdir -p ${DESTDIR}
	cp -r DEBIAN/ ${DESTDIR}
	cp -r lib/ usr/ ${DESTDIR}

# Create the installer pkg
pkg:
	dpkg-deb -b ${DESTDIR}
