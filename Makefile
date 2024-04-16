# Makefile for the installer
# $Ragnarok: Makefile,v 1.3 2024/04/16 15:12:39 lecorbeau Exp $

PKG	= ragnarok-installer

dirs:
	mkdir -p ${DESTDIR}/usr/bin
	mkdir -p ${DESTDIR}/etc/
	mkdir -p ${DESTDIR}/usr/libexec

install: dirs
	cp ${PKG} ${DESTDIR}/usr/bin/
	cp install.conf ${DESTDIR}/etc/
	cp -r usr/libexec/${PKG} ${DESTDIR}/libexec/
	chmod 755 ${DESTDIR}/usr/bin/ragnarok-install
	cd ${DESTDIR}/libexec/ragnarok-installer/hooks/; \
		chmod 755 customize01.sh customize02.sh setup01.sh

deb: install
	/usr/bin/equivs-build ${PKG}.pkg 2>&1 | tee ${PKG}.build
