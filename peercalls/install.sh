#!/bin/bash

echo '# peercalls ########'

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

if ! [[ -d /opt/simplecloud/_config_cache/peercalls ]]; then
	echo 'Directory not found: /opt/simplecloud/_config_cache/peercalls'
	exit 1
fi

# install
apt-get install -y build-essential nodejs
npm i -g peer-calls

# configs
if ! [[ -f /opt/simplecloud/_config_cache/peercalls/default.json ]]; then
	cp $DIR/config.default.json /opt/simplecloud/_config_cache/peercalls/default.json
fi

# permissions
useradd --system --home-dir / --shell /sbin/nologin peercalls

# service
ln -fs $DIR/peercalls.service /lib/systemd/system/
