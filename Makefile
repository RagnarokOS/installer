# Build ragnarok-install package
# $Ragnarok: Makefile,v 1.6 2024/09/18 22:44:07 lecorbeau Exp $

PKG	= ragnarok-installer
VERSION	= 01
DESTDIR	= ${PKG}_${VERSION}

all: 
	mkdir -p ${DESTDIR}
	cp -r DEBIAN/ ${DESTDIR}
	cp -r lib/ usr/ ${DESTDIR}
	rm -r ${DESTDIR}/lib/ragnarok-installer/RCS
	rm ${DESTDIR}/lib/ragnarok-installer/.gitignore
	rm -r ${DESTDIR}/usr/bin/RCS
	rm ${DESTDIR}/usr/bin/.gitignore
	rm -r ${DESTDIR}/usr/share/hooks
	rm -r ${DESTDIR}/usr/share/lists/RCS

# Create the installer pkg
pkg:
	dpkg-deb -b ${DESTDIR}
