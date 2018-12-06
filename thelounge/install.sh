#!/bin/bash

echo '# TheLounge ########'

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

if ! [[ -d /opt/simplecloud/_config_cache/thelounge ]]; then
	echo 'Directory not found: /opt/simplecloud/_config_cache/thelounge'
	exit 1
fi

# install
apt-get install -y build-essential nodejs

npm i -g thelounge@next

# configs
if [[ -f /opt/simplecloud/_config_cache/thelounge/config.js ]]; then
	cp $DIR/config.default.js /opt/simplecloud/_config_cache/thelounge/config.js
fi

touch /var/log/thelounge.log

# permissions
useradd --system --home-dir / --shell /sbin/nologin thelounge

chown thelounge:root -R /opt/simplecloud/_config_cache/thelounge
chmod 770 -R /opt/simplecloud/_config_cache/thelounge

chown thelounge:root /var/log/thelounge.log
chmod 770 /var/log/thelounge.log

# service
ln -fs $DIR/thelounge.service /lib/systemd/system/
