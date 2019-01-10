#!/bin/bash

if [ "$EUID" -ne 0 ]; then
	echo "Please run as root"
	exit 1
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

case `cat $DIR/.distro` in
	'suse' )
		if [[ $@ == *"btrbk"* ]]; then
			zypper install -y curl perl asciidoc mbuffer > /dev/null
			curl -o /usr/local/bin/btrbk https://raw.githubusercontent.com/digint/btrbk/master/btrbk
			chmod +x /usr/local/bin/btrbk
		fi

		zypper install -y `echo $@ | sed -e "s/imagemagick/ImageMagick; s/btrfs-tools/btrfsprogs; s/btrbk//g; s/nodejs/nodejs8/g"` > /dev/null
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
esac
