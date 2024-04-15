# Makefile for the installer
# $Ragnarok: Makefile,v 1.1 2024/04/15 15:27:58 lecorbeau Exp $

install:
	mkdir -p ${DESTDIR}/usr/bin
	mkdir -p ${DESTDIR}/etc/ragnarok-installer
	mkdir -p ${DESTDIR}/usr/libexec
	cp ragnarok-install ${DESTDIR}/usr/bin/
	cp install.conf ${DESTDIR}/etc/ragnarok-installer/
	cp -r usr/libexec/ragnarok-installer ${DESTDIR}/libexec/
	# remove .gitignore. Won't be necessary once the Makefile is
	# done properly.
	rm ${DESTDIR}/usr/libexec/ragnarok-installer/.gitignore
