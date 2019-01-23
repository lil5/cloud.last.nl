#!/bin/bash

if [ "$EUID" -ne 0 ]; then
	echo "Please run as root"
	exit 1
fi

DIR="$(dirname "$(readlink -f "$0")")"
if [[ -z $DIR ]]; then echo 'var DIR is empty'; exit 1; fi

case `cat $DIR/.distro` in
	'suse' )
		if [[ $@ == *"btrbk"* ]]; then
			echo 'zypper installing: curl perl asciidoc mbuffer'
			zypper install -y curl perl asciidoc mbuffer > /dev/null
			curl -Lo /usr/local/bin/btrbk https://raw.githubusercontent.com/digint/btrbk/master/btrbk
			chmod +x /usr/local/bin/btrbk
		fi

		LIST_INSTALL_PKG=`echo " $@" | sed -e "s/ imagemagick/ ImageMagick/g; s/ btrfs-tools/ btrfsprogs/g; s/ btrbk//g; s/ nodejs/ nodejs8/g"`
		echo "zypper installing: $LIST_INSTALL_PKG"
		zypper install -y $LIST_INSTALL_PKG > /dev/null
	;;
	'debian' )
		# has nodejs in list to install and "npm -v" gives error
		if [[ $@ == *"nodejs"* ]] && [[ -z `npm -v 2>/dev/null` ]]; then
			apt install -y curl build-essential
			if [[ -z "$(which gpg)" ]]; then
				apt install -y gnupg
			fi
			curl -sL https://deb.nodesource.com/setup_8.x | bash -
			apt-get update -y
		fi

		apt install -y $@
	;;
	'arch' )
		if [[ $@ == *"apache2"* ]]; then
			yes | pacman -Sq --needed trizen
			sudo -u `ls /home | head -1` trizen -Sa --noedit --needed --noconfim a2enmod-git
		fi

		if [[ $@ == *"btrbk"* ]]; then
			yes | pacman -Sq --needed trizen
			sudo -u `ls /home | head -1` trizen -Sa --noedit --needed --noconfim btrbk
		fi

		LIST_INSTALL_PKG=`echo " $@" | sed -e "s/ btrfs-tools/ btrfs-progs/g; s/ btrbk//g; s/ apache2/ apache/g"`
		yes | pacman -Sq --needed $LIST_INSTALL_PKG
	;;
esac
