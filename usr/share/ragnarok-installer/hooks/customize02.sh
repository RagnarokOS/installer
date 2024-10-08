#!/bin/ksh

# $Ragnarok: customize02.sh,v 1.11 2024/08/26 18:01:05 lecorbeau Exp $

. /lib/ragnarok-installer/funcs

# Global variables
CONF=${CONF:-/install.conf}
_keymap=$(get_val KB_Layout "$CONF")
_variant=$(get_val KB_Variant "$CONF")
_hostname=$(get_val Hostname "$CONF")
_dev=$(get_val Device "$CONF")

# Set locales and console.
set_locale() {
	local _resp _locale _charset _keymap
	
	read -r _resp?"Enter the locale for this system. e.g. en_US.UTF-8 UTF-8. (Type 'l' for a list of supported locales): "

	_locale=${_resp%% *}
	_charset=${_resp##* }
	case "$_resp" in
		l)
			less --prompt="/ to search, j/k to navigate, q to quit, h for help " /usr/share/ragnarok-installer/lists/locales.list; set_locale
			;;
		*)
			echo "locales locales/default_environment_locale select $_locale" \
				| chroot "$1" debconf-set-selections
			echo "locales locales/locales_to_be_generated multiselect $_locale $_charset" \
				| chroot "$1" debconf-set-selections
			chroot "$1" apt-get install locales -y
			# Remove locale.gen. It'll be recreated after dpkg-reconfigure
			rm "$1"/etc/locale.gen
			chroot "$1" dpkg-reconfigure -f noninteractive locales
			;;
	esac

	# Setup the console
	msg "Setting up the console..."
	# Using the setcons script for that in order to keep the installer
	# as small as humanly possible.
	chroot "$1" setcons "$_locale" "$_charset"
	chroot "$1" apt-get install console-setup -y

	# Set the console font to spleen if the codeset is 'Lat15'
	if grep -q "xfonts" "$CONF"; then
		case "$CODESET" in
			Lat15)
				sed -i 's/FONTFACE/#&/' "$1"/etc/default/console-setup
				sed -i 's/FONTSIZE/#&/' "$1"/etc/default/console-setup
				printf '%s\n' 'FONT="spleen-8x16.psfu.gz"' >> "$1"/etc/default/console-setup
				;;
		esac
	fi
}

# Set the timezone
set_tz() {
	local _resp _area _zone

	read -r _resp?"Enter the time zone for this system. e.g. America/New_York. ('l' for a list of supported timezones): "
	
	_area=${_resp%%/*}
	_zone=${_resp##/*}

	case "$_resp" in

		l)	less --prompt="/ to search, j/k to navigate, q to quit, h for help " /usr/share/ragnarok-installer/lists/tz.list; ask_tz "$@"
			;;
		*)
			msg "Setting the timezone..."
			echo "tzdata tzdata/Areas select $_area" \ 
				| chroot "$1" debconf-set-selections
			echo "tzdata tzdata/Zones/$_area select $_zone" \ 
				| chroot "$1" debconf-set-selections
			echo 'tzdata tzdata/Zones/Etc select UTC' \ 
			       | chroot "$1" debconf-set-selections
			# This has to be done or else dpkg-reconfigure insists on using Etc
			# as the default timezone for whatever stupid reason.
			echo "${_area}/${_zone}" > "$1"/etc/timezone
			chroot "$1" ln -sf /usr/share/zoneinfo/"${_area}"/"${_zone}" /etc/localtime
			chroot "$1" dpkg-reconfigure -f noninteractive tzdata
			;;
	esac
}

# Function to set up default user and passwords
set_userpass() {
	local _resp

	msg "Password for the root account (will not echo): "
	chroot "$1" passwd

	read -r _resp?"Name of default user: "
	chroot "$1" useradd -m -s /bin/ksh "$_resp"
	chroot  "$1" usermod -aG wheel,cdrom,floppy,audio,dip,video,plugdev,netdev "$_resp"

	msg "Password for $_resp (will not echo): "
	chroot "$1" passwd "$_resp"
}

# Wrapper function around apt-get. The virt set needs to be installed
# without recommends, so this is how it'll be handled.
installcmd() {
	local _set=$1

	case "$1" in
		virt)	apt-get install --no-install-recommends -y "$_set"
			;;
		*)	apt-get install -y "$_set"
			;;
	esac
}

# Install the sets.
install_sets() {
	local _sets 

	set -A _sets -- $(sed -n 's/Sets = //p' install.conf)

	msg "Installing the sets..."
	if [[ ${_sets[*]} == none ]]; then
		msg "No sets selected, skipping..."
	else
		for _set in "${_sets[@]}"; do
			installcmd "ragnarok-${_set}"
		done
	fi
}

## Actual script

# Set up fstab
msg "Generating fstab entries..."
genfstab -U "$1" >> "$1"/etc/fstab

# Copy network files
msg "Setting up network interfaces..."

# copy interfaces files.
/usr/bin/mkdir -p "$1"/etc/network
/usr/bin/cp /etc/network/interfaces "$1"/etc/network/

# Copy /etc/network/interfaces.d/ if there's anything in it.
if [[ -z $(find /etc/network/interfaces.d/ -prune -empty 2>/dev/null) ]]; then
	/usr/bin/cp -r /etc/network/interfaces.d/ "$1"/etc/network/
fi

# Set locales
msg "Setting up locales..."
echo "locales locales/default_environment_locale select $_locale" \
	| chroot "$1" debconf-set-selections
echo "locales locales/locales_to_be_generated multiselect $_locale $_charset" \
	| chroot "$1" debconf-set-selections
chroot "$1" apt-get install locales -y
# Remove locale.gen. It'll be recreated after dpkg-reconfigure
rm "$1"/etc/locale.gen
chroot "$1" dpkg-reconfigure -f noninteractive locales

# Setting the timezone
msg "Setting the timezone..."
echo "tzdata tzdata/Areas select $_area" | chroot "$1" debconf-set-selections
echo "tzdata tzdata/Zones/$_area select $_zone" | chroot "$1" debconf-set-selections
echo 'tzdata tzdata/Zones/Etc select UTC' | chroot "$1" debconf-set-selections
# This has to be done or else dpkg-reconfigure insists on using Etc
# as the default timezone for whatever stupid reason.
echo "${_area}/${_zone}" > "$1"/etc/timezone
chroot "$1" ln -sf /usr/share/zoneinfo/"${_area}"/"${_zone}" /etc/localtime
chroot "$1" dpkg-reconfigure -f noninteractive tzdata

# Setup the console
msg "Setting up the console..."
# Using the setcons script for that in order to keep the installer
# as small as humanly possible.
setcons "$_locale" "$_charset"
chroot "$1" apt-get install console-setup -y

# Set the console font to spleen if the codeset is 'Lat15'
if grep -q "xfonts" "$CONF"; then
	case "$CODESET" in
		Lat15)
			sed -i 's/FONTFACE/#&/' "$1"/etc/default/console-setup
			sed -i 's/FONTSIZE/#&/' "$1"/etc/default/console-setup
			printf '%s\n' 'FONT="spleen-8x16.psfu.gz"' >> "$1"/etc/default/console-setup
			;;
	esac
fi

# Set keymap
msg "Setting up the keyboard..."
printf '%s\n' "XKBMODEL=\"pc105\"
XKBLAYOUT=\"$_keymap\"
XKBVARIANT=\"\"
XKBOPTIONS=\"\"

BACKSPACE=\"guess\"" > "$1"/etc/default/keyboard
chroot "$1" dpkg-reconfigure -f noninteractive keyboard-configuration

# Setup /etc/hosts and /etc/hostname
msg "Setting up hostname and hosts file..."
sed -i "s/ragnarok/$_hostname/g" "$1"/etc/hostname
sed -i "2i 127.0.1.1\t${_hostname}" "$1"/etc/hosts

# Set root password + default user/pass
set_userpass "$@"

# Install the kernel
msg "Installing kernels..."
chroot "$1" apt-get install linux-image-amd64 -y
chroot "$1" kernupd -d
chroot "$1" kernupd -i

# Install the sets. Will it work that way? Let's find out.
chroot "$1" install_sets

# Install the bootloader.
msg "Installing the bootloader..."
if [ -d "$1"/boot/efi ]; then
	# Install grub-efi
	chroot "$1" apt-get install grub-efi-amd64
	chroot "$1" grub-install --target=x86_64-efi \
		--efi-directory=/boot/efi
	chroot "$1" update-grub
else
	# Install/Configure extlinux
	chroot "$1" apt-get install extlinux
	chroot "$1" syslinux-install "${_dev}1"
fi

# Update the manual pages
msg "Updating manual pages database..."
chroot "$1" /usr/sbin/makewhatis /usr/share/man/
