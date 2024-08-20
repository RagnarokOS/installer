#!/bin/ksh

# $Ragnarok: customize02.sh,v 1.7 2024/08/20 23:09:19 lecorbeau Exp $

. /lib/ragnarok-installer/funcs

# Global variables
CONF=${CONF:-/install.conf}
_locale=$(get_val Locale "$CONF")
_charset=$(awk '/Locale/ { print $4 }' "$CONF")
_keymap=$(get_val KB_Layout "$CONF")
_variant=$(get_val KB_Variant "$CONF")
_hostname=$(get_val Hostname "$CONF")
_dev=$(get_val Device "$CONF")

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
chroot "$1" apt-get install locales -y
chroot "$1" dpkg-reconfigure -f noninteractive locales

# Setting the timezone
msg "Setting the timezone..."
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
sed -i "s/ragnarok/$_hostname/g" "$1"/etc/hosts "$1"/etc/hostname

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
