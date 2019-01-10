#!/bin/bash

echo '# distro ###########'

if [ "$EUID" -ne 0 ]; then
	echo "Please run as root"
	exit 1
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

if [[ `uname` == "Linux" ]]; then
	if [[ -f /etc/redhat-release ]]; then
		DistroBasedOn='RedHat'
	elif [[ -f /etc/slackware-version ]]; then
		DistroBasedOn='Slackware'
	elif [[ -f /etc/SuSE-release ]]; then
		DistroBasedOn='SuSe'
	elif [[ -f /etc/mandrake-release ]]; then
		DistroBasedOn='Mandrake'
	elif [[ -f /etc/arch-release ]]; then
		DistroBasedOn='Arch'
	elif [[ -f /etc/debian_version ]]; then
		DistroBasedOn='Debian'
	else
		echo "Distro not found"
		exit 1
	fi
else
	echo "Please run on Linux system"
	exit 1
fi

case $DistroBasedOn in
	'SuSe' )
		printf 'suse' > $DIR/.distro
	;;
	'Debian' )
		printf 'debian' > $DIR/.distro
	;;
	*)
		echo 'Not supported yet'
		echo 'See "/opt/simplecloud/distro/"'
		exit 1
	;;
esac
