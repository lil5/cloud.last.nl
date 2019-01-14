#!/bin/bash

echo '# Radicale #########'

DIR="$(dirname "$(readlink -f "$0")")"
if [[ -z $DIR ]]; then echo 'var DIR is empty'; exit 1; fi

DISTRO=`cat $DIR/../distro/.distro`

if ! [[ -d /opt/simplecloud/_config_cache/radicale ]]; then
	echo 'Directory not found: /opt/simplecloud/_config_cache/radicale'
	exit 1
fi

# install
$DIR/../distro/pm-install.sh python3 python3-pip
python3 -m pip install --upgrade radicale bcrypt passlib

# configs
if ! [[ -f /opt/simplecloud/_config_cache/radicale/config.ini ]]; then
	cp $DIR/config.default.ini /opt/simplecloud/_config_cache/radicale/config.ini
fi

if ! [[ -f /opt/simplecloud/_config_cache/users.passwd ]]; then
	# user:bcryptpassword
	cp $DIR/users.default.passwd /opt/simplecloud/_config_cache/users.passwd
fi

touch /var/log/radicale.log

# permissions
useradd --system --home-dir / --shell /sbin/nologin -u 1104 radicale
usermod -a -G 1100 radicale

chown radicale:root /var/log/radicale.log
chmod 775 /var/log/radicale.log

chown radicale:1100 /opt/simplecloud/_config_cache/users.passwd
chmod 770 /opt/simplecloud/_config_cache/users.passwd

chown radicale:root -R /opt/simplecloud/_config_cache/radicale
chmod 770 -R /opt/simplecloud/_config_cache/radicale

# service
case $DISTRO in
	'suse' )
		ln -fs $DIR/radicale.service /usr/lib/systemd/system/
	;;
	'debian' )
		ln -fs $DIR/radicale.service /lib/systemd/system/
	;;
esac
