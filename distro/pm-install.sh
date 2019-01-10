#!/bin/bash

if [ "$EUID" -ne 0 ]; then
	echo "Please run as root"
	exit 1
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

case `cat $DIR/.distro` in
	'suse' )
		if [[ $@ =~ 'btrbk' ]]; then
			zypper install -y curl perl asciidoc mbuffer > /dev/null
			curl -o /usr/local/bin/btrbk https://raw.githubusercontent.com/digint/btrbk/master/btrbk
			chmod +x /usr/local/bin/btrbk
		fi
		zypper install -y $($@ | sed "s/imagemagick/ImageMagick" | sed "s/btrfs-tools/btrfsprogs") | sed "s/btrbk//g") > /dev/null
	;;
	'debian' )
		apt install -y $@
	;;
esac
