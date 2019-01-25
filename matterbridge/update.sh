#!/bin/bash

ARCH=''
case $(uname -m) in
	i386|i686)
		ARCH=386
		;;
	amd64|x86_64)
		ARCH=amd64
		;;
	arm*)
		ARCH=arm
		;;
	*)
		echo "Error: architecture invalid \"${uname -m}\""
		exit 1
		;;
esac

MATTERBRIDGE_DL_URL="$(curl -s https://api.github.com/repos/42wim/matterbridge/releases/latest | grep browser_download_url | cut -d '"' -f 4 | grep -i linux-${ARCH})"

if [[ -z $MATTERBRIDGE_DL_URL ]]; then
	echo 'Error: Matterbridge download not working!'
	exit 1
fi
mv /usr/local/bin/matterbridge /tmp/matterbridge.old
curl -Lo /usr/local/bin/matterbridge $MATTERBRIDGE_DL_URL
chmod +x /usr/local/bin/matterbridge
