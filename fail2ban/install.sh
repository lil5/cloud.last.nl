#!/bin/bash

echo '# fail2ban #########'

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

if ! [[ -d /opt/simplecloud/_config_cache/fail2ban ]]; then
	echo 'Directory not found: /opt/simplecloud/_config_cache/fail2ban'
	exit 1
fi

# install
apt-get install -y fail2ban
systemctl enable fail2ban

# configs
if ! [[ -f /opt/simplecloud/_config_cache/fail2ban/jail.local ]]; then
	cp $DIR/jail.default.local /opt/simplecloud/_config_cache/fail2ban/jail.local
	ln -sf /opt/simplecloud/_config_cache/fail2ban/jail.local /etc/fail2ban/
fi

cp $DIR/filter.d/* /etc/fail2ban/filter.d/
