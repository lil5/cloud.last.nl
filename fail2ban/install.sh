#!/bin/bash

echo '# fail2ban #########'

DIR="$(dirname "$(readlink -f "$0")")"
if [[ -z $DIR ]]; then echo 'var DIR is empty'; exit 1; fi

if ! [[ -d /opt/simplecloud/_config_cache/fail2ban ]]; then
	echo 'Directory not found: /opt/simplecloud/_config_cache/fail2ban'
	exit 1
fi

# install
$DIR/../distro/pm-install.sh fail2ban
systemctl enable fail2ban

# configs
if ! [[ -f /opt/simplecloud/_config_cache/fail2ban/jail.local ]]; then
	cp $DIR/jail.default.local /opt/simplecloud/_config_cache/fail2ban/jail.local
	ln -sf /opt/simplecloud/_config_cache/fail2ban/jail.local /etc/fail2ban/
fi

cp $DIR/filter.d/* /etc/fail2ban/filter.d/

systemctl restart fail2ban
