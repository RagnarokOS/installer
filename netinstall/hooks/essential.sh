#!/bin/ksh

# Set the locale and timezone before installing anything after the
# 'essential:yes' packages. This avoids some useless errors during
# install.

# $Ragnarok: essential.sh,v 1.4 2024/08/20 19:47:30 lecorbeau Exp $

. /lib/ragnarok-installer/funcs

CONF=${CONF:-install.conf}

_locale=$(get_val Locale "$CONF")
_charset=$(awk '/Locale/ { print $4 }' "$CONF")
_tz=$(get_val Timezone "$CONF")
_area=${_tz%%/*}
_zone=${_tz##/*}

# copy install.conf to the chroot
cp "$CONF" "$1"/

msg "Setting up locales..."
echo "locales locales/default_environment_locale select $_locale" \
	| chroot "$1" debconf-set-selection
echo "locales locales_to_be_generated multiselect $_locale $_charset" \
	| chroot "$1" debconf-set-selections

msg "Setting the timezone..."
echo "tzdata tzdata/Areas select $_area" | chroot "$1" debconf-set-selections
echo "tzdata tzdata/Zones/$_area select $_zone" | chroot "$1" debconf-set-selections
echo 'tzdata tzdata/Zones/Etc select UTC' | chroot "$1" debconf-set-selections

# This has to be done or else dpkg-reconfigure insists on using Etc
# as the default timezone for whatever stupid reason.
echo "${_area}/${_zone}" > "$1"/etc/timezone
chroot "$1" ln -sf /usr/share/zoneinfo/"${_area}"/"${_zone}" /etc/localtime
