#!/bin/bash

echo '# openssl ##########'

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

if ! [[ -d /opt/simplecloud/_config_cache/openssl ]]; then
	echo 'Directory not found: /opt/simplecloud/_config_cache/openssl'
	exit 1
fi

# variables

echo 'Enter LAN domain name (without port)'
read LAN_DOMAIN

echo 'Enter WAN IP address (without port)'
read WAN_IP

HOSTNAME="$(hostname)"

# install

apt-get install -y openssl

chmod +x $DIR/bin/*-gen

if ! [[ -f /opt/simplecloud/_config_cache/openssl/root-ca.crt ]]; then
	echo '-----Generate Root CA-----'

	$DIR/bin/ca-gen -v \
	-n "SimpleCloud SHA256 CA" \
	-o SimpleCloud \
	-u "$HOSTNAME" \
	-d 18262 \
	\
	/opt/simplecloud/_config_cache/openssl/root-ca.key \
	/opt/simplecloud/_config_cache/openssl/root-ca.crt
fi

echo '-----Generate Site Certificate-----'

$DIR/bin/cert-gen -v \
-n "$LAN_DOMAIN" \
-o SimpleCloud \
-u "$HOSTNAME" \
-i "$WAN_IP" \
\
/opt/simplecloud/_config_cache/openssl/root-ca.key \
/opt/simplecloud/_config_cache/openssl/root-ca.crt \
\
/opt/simplecloud/_config_cache/openssl/site.key \
/opt/simplecloud/_config_cache/openssl/site.csr \
/opt/simplecloud/_config_cache/openssl/site.crt

mkdir -p /var/www/dash ||:
cp /opt/simplecloud/_config_cache/openssl/root-ca.crt /var/www/dash/simplecloud.crt

# permissions

chown www-data:www-data -R /var/www/dash

chown root:root -R /opt/simplecloud/_config_cache/openssl
chmod 700 -R /opt/simplecloud/_config_cache/openssl
