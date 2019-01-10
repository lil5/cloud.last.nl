#!/bin/bash

if [ "$EUID" -ne 0 ]; then
	echo "Please run as root"
	exit 1
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

case `cat $DIR/.distro` in
	'suse' )
	;;
	'debian' )
		apt update -y
	;;
esac
