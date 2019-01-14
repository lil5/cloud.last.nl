#!/bin/bash

echo '# Mini IRC #########'

DIR="$(dirname "$(readlink -f "$0")")"
if [[ -z $DIR ]]; then echo 'var DIR is empty'; exit 1; fi

DISTRO=`cat $DIR/../distro/.distro`

if ! [[ -d /opt/simplecloud/_config_cache/miniircd ]]; then
	echo 'Directory not found: /opt/simplecloud/_config_cache/miniircd'
	exit 1
fi

# install
$DIR/../distro/pm-install.sh curl python3 openssl

curl -Lo /usr/local/bin/miniircd https://raw.githubusercontent.com/jrosdahl/miniircd/master/miniircd

# configs

if ! [[ -f /opt/simplecloud/_config_cache/miniircd/passwd.txt ]]; then
	openssl rand -hex 20 > /opt/simplecloud/_config_cache/miniircd/passwd.txt
fi

# permissions
useradd --system --home-dir / --shell /sbin/nologin -u 1102 miniircd

chmod +x /usr/local/bin/miniircd

chmod 770 -R /opt/simplecloud/_config_cache/miniircd/
chown miniircd:root -R /opt/simplecloud/_config_cache/miniircd/

# service
case $DISTRO in
	'suse' )
		ln -fs $DIR/miniircd.service /usr/lib/systemd/system/
	;;
	'debian' )
		ln -fs $DIR/miniircd.service /lib/systemd/system/
	;;
esac
