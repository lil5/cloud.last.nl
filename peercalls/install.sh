#!/bin/bash

echo '# peercalls ########'

DIR="$(dirname "$(readlink -f "$0")")"
if [[ -z $DIR ]]; then echo 'var DIR is empty'; exit 1; fi

DISTRO=`cat $DIR/../distro/.distro`

if ! [[ -d /opt/simplecloud/_config_cache/peercalls ]]; then
	echo 'Directory not found: /opt/simplecloud/_config_cache/peercalls'
	exit 1
fi

# install
$DIR/../distro/pm-install.sh nodejs
npm i -g peer-calls

# configs
if ! [[ -f /opt/simplecloud/_config_cache/peercalls/default.json ]]; then
	cp $DIR/config.default.json /opt/simplecloud/_config_cache/peercalls/default.json
fi

# permissions
useradd --system --home-dir / --shell /sbin/nologin -u 1103 peercalls

# service
case $DISTRO in
	'suse' )
		ln -fs $DIR/peercalls.service /usr/lib/systemd/system/
	;;
	'debian' )
		ln -fs $DIR/peercalls.service /lib/systemd/system/
	;;
esac
