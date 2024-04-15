# Makefile for the installer
# $Ragnarok: Makefile,v 1.2 2024/04/15 16:41:07 lecorbeau Exp $

PKG	= ragnarok-installer

dirs:
	mkdir -p ${DESTDIR}/usr/bin
	mkdir -p ${DESTDIR}/etc/
	mkdir -p ${DESTDIR}/usr/libexec

install: dirs
	cp ${PKG} ${DESTDIR}/usr/bin/
	cp install.conf ${DESTDIR}/etc/
	cp -r usr/libexec/${PKG} ${DESTDIR}/libexec/

deb: install
	/usr/bin/equivs-build ${PKG}.pkg 2>&1 | tee ${PKG}.build
