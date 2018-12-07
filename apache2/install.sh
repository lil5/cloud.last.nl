#!/bin/bash

echo '# apache2 ##########'

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

if ! [[ -d /opt/simplecloud/_config_cache/apache2 ]]; then
	echo 'Directory not found: /opt/simplecloud/_config_cache/apache2'
	exit 1
fi
if ! [[ -d /data/simplecloud/storage ]]; then
	echo 'Directory not found: /data/simplecloud/storage'
	exit 1
fi

# install
apt-get install -y apache2 unzip

a2enmod \
	proxy \
	proxy_ajp \
	proxy_http \
	rewrite \
	deflate \
	headers \
	proxy_balancer \
	proxy_connect \
	proxy_html \
	dav \
	dav_fs \
	ssl

systemctl disable apache2
systemctl stop apache2

# configs
if ! [[ -f /opt/simplecloud/_config_cache/apache2/config.conf ]]; then
	cp $DIR/config.default.conf /opt/simplecloud/_config_cache/apache2/config.conf
fi

mkdir /var/www/dash
unzip $DIR/simple-dash.zip -d /var/www/dash/
if ! [[ -f /opt/simplecloud/_config_cache/apache2/config.json ]]; then
	cp $DIR/config.default.json /opt/simplecloud/_config_cache/apache2/config.json
fi
ln -sf /opt/simplecloud/_config_cache/apache2/config.json /var/www/dash/

rm /etc/apache2/sites-enabled/*.conf

ln -sf /opt/simplecloud/_config_cache/apache2/config.conf /etc/apache2/sites-enabled/

# permissions
chown www-data:www-data -R /data/simplecloud/storage
chown www-data:www-data -R /var/www/dash
