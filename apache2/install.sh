#!/bin/bash

echo '# apache2 ##########'

DIR="$(dirname "$(readlink -f "$0")")"
if [[ -z $DIR ]]; then echo 'var DIR is empty'; exit 1; fi

DISTRO=`cat $DIR/../distro/.distro`

if ! [[ -d /opt/simplecloud/_config_cache/apache2 ]]; then
	echo 'Directory not found: /opt/simplecloud/_config_cache/apache2'
	exit 1
fi
if ! [[ -d /data/simplecloud/storage ]]; then
	echo 'Directory not found: /data/simplecloud/storage'
	exit 1
fi

# install
$DIR/../distro/pm-install.sh apache2 unzip

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
case $DISTRO in
	'suse' )
		mkdir /var/www
	;;
esac

if ! [[ -f /opt/simplecloud/_config_cache/apache2/config.conf ]]; then
	cp $DIR/config.default.conf /opt/simplecloud/_config_cache/apache2/config.conf
fi

mkdir /var/www/dash
unzip $DIR/simple-dash.zip -d /var/www/dash/
if ! [[ -f /opt/simplecloud/_config_cache/apache2/config.json ]]; then
	cp $DIR/config.default.json /opt/simplecloud/_config_cache/apache2/config.json
fi
ln -sf /opt/simplecloud/_config_cache/apache2/config.json /var/www/dash/

case $DISTRO in
	'suse' )
		rm /etc/apache2/vhost.d/*.conf
		ln -sf /opt/simplecloud/_config_cache/apache2/config.conf /etc/apache2/vhosts.d/
	;;
	'debian' )
		rm /etc/apache2/sites-enabled/*.conf
		ln -sf /opt/simplecloud/_config_cache/apache2/config.conf /etc/apache2/sites-enabled/
	;;
esac

# permissions
case $DISTRO in
	'suse' )
		usermod -u 1100 wwwrun
		groupmod -g 1300 www
	;;
	'debian' )
		usermod -u 1100 www-data
		groupmod -g 1300 www-data
	;;
esac

chown 1100:root -R /data/simplecloud/storage
chown 1100:root -R /var/www/dash
