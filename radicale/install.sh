#!/bin/bash

echo '# Radicale #########'

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

if ! [[ -d /opt/simplecloud/_config_cache/radicale ]]; then
	echo 'Directory not found: /opt/simplecloud/_config_cache/radicale'
	exit 1
fi

# install
apt-get install -y python3 python3-pip
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
useradd --system --home-dir / --shell /sbin/nologin radicale
usermod -a -G www-data radicale

chown radicale:root /var/log/radicale.log
chmod 775 /var/log/radicale.log

chown radicale:www-data /opt/simplecloud/_config_cache/users.passwd
chmod 770 /opt/simplecloud/_config_cache/users.passwd

chown radicale:root -R /opt/simplecloud/_config_cache/radicale
chmod 770 -R /opt/simplecloud/_config_cache/radicale

# service
ln -fs $DIR/radicale.service /lib/systemd/system/
