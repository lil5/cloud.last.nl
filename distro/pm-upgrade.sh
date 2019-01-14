#!/bin/bash

if [ "$EUID" -ne 0 ]; then
	echo "Please run as root"
	exit 1
fi

DIR="$(dirname "$(readlink -f "$0")")"
if [[ -z $DIR ]]; then echo 'var DIR is empty'; exit 1; fi

case `cat $DIR/.distro` in
	'suse' )
		zypper update -y > /dev/null
		if [[ -f /usr/local/bin/btrbk ]]; then
			curl -Lo /usr/local/bin/btrbk https://raw.githubusercontent.com/digint/btrbk/master/btrbk
			chmod +x /usr/local/bin/btrbk
		fi
	;;
	'debian' )
		apt update -y && apt upgrade -y
	;;
esac
