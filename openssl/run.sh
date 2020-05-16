#!/bin/bash

echo '# openssl ##########'

DIR="$(dirname "$(readlink -f "$0")")"
if [[ -z $DIR ]]; then echo 'var DIR is empty'; exit 1; fi

# variables

echo 'Enter WAN domain name (without port)'
read WAN_DOMAIN

echo 'Enter LAN IP address (without port)'
read LAN_IP

HOSTNAME="$(hostname)"

chmod +x $DIR/bin/*-gen

if ! [[ -f $DIR/certs/root-ca.crt ]]; then
	echo '-----Generate Root CA-----'

	$DIR/bin/ca-gen -v \
	-n "SimpleCloud SHA256 CA" \
	-o SimpleCloud \
	-u "$HOSTNAME" \
	-d 18262 \
	\
	$DIR/certs/root-ca.key \
	$DIR/certs/root-ca.crt
fi

echo '-----Generate Site Certificate-----'

$DIR/bin/cert-gen -v \
-n "$WAN_DOMAIN" \
-o SimpleCloud \
-u "$HOSTNAME" \
-i "$LAN_IP" \
\
$DIR/certs/root-ca.key \
$DIR/certs/root-ca.crt \
\
$DIR/certs/site.key \
$DIR/certs/site.csr \
$DIR/certs/site.crt
