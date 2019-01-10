#!/bin/bash

if [ "$EUID" -ne 0 ]; then
	echo "Please run as root"
	exit 1
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

case `cat $DIR/.distro` in
	'suse' )
		zypper update -y > /dev/null
		if [[ -f /usr/local/bin/btrbk ]]; then
			curl -o /usr/local/bin/btrbk https://raw.githubusercontent.com/digint/btrbk/master/btrbk
			chmod +x /usr/local/bin/btrbk
		fi
	;;
	'debian' )
		apt update -y && apt upgrade -y
	;;
esac
