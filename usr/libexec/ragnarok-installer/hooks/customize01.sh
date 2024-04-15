#!/bin/ksh

# Initial system config.
# $Ragnarok: customize01.sh,v 1.12 2024/04/15 15:13:06 lecorbeau Exp $

set -e

# This is shorter than constantly writing the printf command
msg() {
	local _msg=$1

	printf '%s\n' "$_msg"
}

# Set up fstab
gfstab() {
	msg "Generating fstab entries..."
	genfstab -U /mnt >> /mnt/etc/fstab
}

# Copy network files
set_net() {
	msg "Setting up network interfaces"
	/usr/bin/cp /etc/network/interfaces "$1"/etc/network/
	/usr/bin/cp -r /etc/network/interfaces.d/ "$1"/etc/network/
}

# Setting the timezone
set_tz() {
	/usr/sbin/chroot "$1" dpkg-reconfigure tzdata
}

# Setup /etc/hosts and /etc/hostname
set_hosts() {
	local _resp

	read -r _resp?"Enter the hostname of the machine: "
	msg "$_resp" > "$1"/etc/hostname
	msg "127.0.0.1   localhost
127.0.1.1   $_resp


# IPv6
::1         localhost ip6-localhost ip6-loopback
ff02::1     ip6-allnodes
ff02::2     ip6-allrouters" > "$1"/etc/hosts
}

# Set locales and keyboard config
set_lokb() {
	msg "Setting up locales and keyboard config..."
	/usr/sbin/chroot "$1" apt-get install locales -y
	/usr/sbin/chroot "$1" dpkg-reconfigure locales
	/usr/sbin/chroot "$1" apt-get install console-setup -y
}

# Set root password
set_rootpass() {
	msg "Password for the root account (will not echo)"
	/usr/sbin/chroot "$1" passwd
}

# Setup a default user name and password
set_user() {
	local _resp

	read -r _resp?"Name of default user: "
	/usr/sbin/chroot "$1" useradd -m "$_resp"
	/usr/sbin/chroot "$1" usermod -aG wheel,cdrom,floppy,audio,dip,video,plugdev,netdev "$_resp"
	/usr/sbin/chroot "$1" usermod -s /bin/ksh "$_resp"

	msg "Password for $_resp (will not echo)"
	/usr/sbin/chroot passwd "$_resp"
}

# Ask user which kernel to install.
# Should this be done here? Might be better to let users decide after system installation.
inst_kern() {
	local _resp

	read -r _resp?"Ragnarok provides an experimental kernel built with LLVM/Clang, which has many security options built-in (such as Control Flow Integrity) and makes
use of Clang's ThinLTO feature. Although no critical bug has been found, this kernel has not been tested on enough hardware which means there may be unknown bugs. You can
choose between installing this kernel alone (not recommended), installing only the standard Debian kernel, or both (with the Ragnarok kernel as default). Do note that the
Ragnarok kernel does not support secure boot, and you will need to use the kernupd(8) command to update.

1) Install both (default).
2) Install only the Ragnarok kernel.
3) Install only Debian's kernel.

Choice? "

	case "$_resp" in
		1)	chroot "$1" kernupd
			chroot "$1" apt-get install linux-image-amd64
			;;
		2)	chroot "$1" kernupd
			;;
		3)	chroot "$1" apt-get install linux-image-amd64
			;;
		*)	chroot "$1" kernupd
			chroot "$1" apt-get install linux-image-amd64
			;;
	esac
}



# Let user decide which set(s) to install.
# NOTE: This will need to be tested on its own first.
install_sets() {
	local _resp _sets

	read -r _resp?"The following sets will be installed:
[x] base    | The base system.
[x] devel   | The git, build-essential and LLVM/Clang toolchain.
[x] xfonts  | Extra fonts for xserv.
[x] xprogs  | Window Managers (Raven, cwm) + ragnarok-terminal and dmenu.
[x] xserv   | Minimal xorg + xinit.

To omit one or more set, simply type <setname> (e.g. xfonts, or xfonts xprogs xserv). Then press Return to install the sets: "

	# If no set was deselected, proceed, else remove deselected first.
	if [[ -z $_resp ]]; then
		_resp="all"
	fi

	case "$_resp" in
		all)	msg "Installing all sets."
			;;
		*)	for _set in $_resp; do
				sed -i -e "s/ $_set//g" install.conf
			done
			;;
	esac

	set -A _sets -- $(sed -n 's/Sets = //p' install.conf)
	for _set in "${_sets[@]}"; do
		chroot "$1" /usr/bin/apt-get install "$_set"
	done
}

# Enable the wheel group.
setup_wheel() {
	sed -i '15 s/^# //' /etc/pam.d/su
	addgroup --system wheel
}

# Setup grub
set_grub() {
	local _resp

	msg "Installing grub..."
	if [ -d "$1"/boot/efi ]; then
		# Install grub-efi
		chroot "$1" apt-get install grub-efi-amd64
		chroot "$1" grub-install --target=x86_64-efi \
			--efi-directory=/boot/efi
	else
		# Install grub-pc
		chroot "$1" apt-get install grub
		msg "Listing available devices..."
		chroot "$1" lsblk
		read -r _resp?"Which device should the bootloader be installed on? (e.g. /dev/sdX) "
		chroot "$1" grub-install "$_resp"
	fi
	chroot "$1" update-grub
}

# Main 
main() {
	gfstab
	set_net
	set_tz
	set_hosts
	set_lokb
	set_rootpass
	set_user
	setup_wheel
	inst_kern
	install_sets
	set_grub
}
main
