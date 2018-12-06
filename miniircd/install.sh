#!/bin/bash

echo '# Mini IRC #########'

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

if ! [[ -d /opt/simplecloud/_config_cache/miniircd ]]; then
	echo 'Directory not found: /opt/simplecloud/_config_cache/miniircd'
	exit 1
fi

# install
apt-get install -y curl python3 openssl

curl -o /usr/local/bin/miniircd https://raw.githubusercontent.com/jrosdahl/miniircd/master/miniircd

# configs

if ! [[ -f /opt/simplecloud/_config_cache/miniircd/passwd.txt ]]; then
	openssl rand -base64 45 > /opt/simplecloud/_config_cache/miniircd/passwd.txt
fi

# permissions
useradd --system --home-dir / --shell /sbin/nologin miniircd

chmod +x /usr/local/bin/miniircd

chmod 770 -R /opt/simplecloud/_config_cache/miniircd/
chown miniircd:root -R /opt/simplecloud/_config_cache/miniircd/

# service
ln -fs $DIR/miniircd.service /lib/systemd/system/
