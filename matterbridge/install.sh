#!/bin/bash

echo '# Matterbridge #####'

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

if ! [[ -d /opt/simplecloud/_config_cache/matterbridge ]]; then
	echo 'Directory not found: /opt/simplecloud/_config_cache/matterbridge'
	exit 1
fi

# install
apt-get install -y curl grep

ARCH=''
case $(uname -m) in
	i386|i686)
		ARCH=386
		;;
	amd64)
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
	# todo copy offline backup
	echo 'Error: Matterbridge download not working!'
	exit 1
else
	curl -o /usr/local/bin/matterbridge $MATTERBRIDGE_DL_URL
fi

# configs
if ! [[ -f /opt/simplecloud/_config_cache/matterbridge/config.toml ]]; then
	cp $DIR/config.default.toml /opt/simplecloud/_config_cache/matterbridge/config.toml
fi

# permissions
useradd --system --home-dir / --shell /sbin/nologin -u 1101 matterbridge

chmod +x /usr/local/bin/matterbridge

chown matterbridge:root -R /opt/simplecloud/_config_cache/matterbridge
chmod 770 -R /opt/simplecloud/_config_cache/matterbridge

# service
ln -fs $DIR/matterbridge.service /lib/systemd/system/
