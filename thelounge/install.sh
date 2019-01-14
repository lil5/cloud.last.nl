#!/bin/bash

echo '# TheLounge ########'

DIR="$(dirname "$(readlink -f "$0")")"
if [[ -z $DIR ]]; then echo 'var DIR is empty'; exit 1; fi

DISTRO=`cat $DIR/../distro/.distro`

if ! [[ -d /opt/simplecloud/_config_cache/thelounge ]]; then
	echo 'Directory not found: /opt/simplecloud/_config_cache/thelounge'
	exit 1
fi

$DIR/../distro/pm-install.sh nodejs
npm i -g thelounge@next

# configs
if [[ -f /opt/simplecloud/_config_cache/thelounge/config.js ]]; then
	cp $DIR/config.default.js /opt/simplecloud/_config_cache/thelounge/config.js
fi

touch /var/log/thelounge.log

# permissions
useradd --system --home-dir / --shell /sbin/nologin -u 1105 thelounge

chown thelounge:root -R /opt/simplecloud/_config_cache/thelounge
chmod 770 -R /opt/simplecloud/_config_cache/thelounge

chown thelounge:root /var/log/thelounge.log
chmod 770 /var/log/thelounge.log

# service
case $DISTRO in
	'suse' )
		ln -fs $DIR/thelounge.service /usr/lib/systemd/system/
	;;
	'debian' )
		ln -fs $DIR/thelounge.service /lib/systemd/system/
	;;
esac
