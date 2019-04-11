#!/bin/bash

echo '# Crontab UI ########'

DIR="$(dirname "$(readlink -f "$0")")"
if [[ -z $DIR ]]; then echo 'var DIR is empty'; exit 1; fi

DISTRO=`cat $DIR/../distro/.distro`

$DIR/../distro/pm-install.sh nodejs
pushd /usr/local/lib
git clone --depth 1 https://github.com/buddy-ekb/crontab-ui crontab-ui
cd crontab-ui
npm install
popd

# permissions
#useradd --system --home-dir / --shell /sbin/nologin -u 1106 crontabui

# service
case $DISTRO in
	'suse' )
		ln -fs $DIR/crontabui.service /usr/lib/systemd/system/
	;;
	'debian'|'arch' )
		ln -fs $DIR/crontabui.service /lib/systemd/system/
	;;
esac
