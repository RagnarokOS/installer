# $Ragnarok: Makefile,v 1.5 2025/04/10 19:58:31 lecorbeau Exp $
# Install the Ragnarok system. Work In Progress.

include config.mk

ifdef MAKE_DEV
	include dev.mk
endif
ifndef DEVICE
	DEVICE = none
endif

all:
	install -d ${TARGET}
	scripts/download ${STAGE3}
	scripts/verify-sig ${SIGKEY} ${STAGE3}

dev:
ifeq (${DEVICE},none)
	@echo "Device already configured and mounted, skipping..."
else
	@cp scripts/mkdev.in scripts/mkdev
	@sed -i	-e "s|@TARGET@|${TARGET}|g" \
		-e "s|@DEVICE@|${DEVICE}|g" \
		-e "s|@BOOTMODE@|${BOOTMODE}|g" \
		-e "s|@BOOTPART@|${BOOTPART}|g" \
		-e "s|@BOOTSIZE@|${BOOTSIZE}|g" \
		-e "s|@SWAPPART@|${SWAPPART}|g" \
		-e "s|@SWAPSIZE@|${SWAPSIZE}|g" \
		-e "s|@ROOTPART@|${ROOTPART}|g" \
		-e "s|@ROOTSIZE@|${ROOTSIZE}|g" \
		-e "s|@HOMEPART@|${HOMEPART}|g" \
		-e "s|@HOMESIZE@|${HOMESIZE}|g" \
		scripts/mkdev
	@scripts/mkdev
endif
