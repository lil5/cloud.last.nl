SHELL = /bin/bash

default:
	@echo ' __ _                 _        ___ _                 _ '
	@echo '/ _(_)_ __ ___  _ __ | | ___  / __\ | ___  _   _  __| |'
	@echo '\ \| | '\''_ ` _ \| '\''_ \| |/ _ \/ /  | |/ _ \| | | |/ _` |'
	@echo '_\ \ | | | | | | |_) | |  __/ /___| | (_) | |_| | (_| |'
	@echo '\__/_|_| |_| |_| .__/|_|\___\____/|_|\___/ \__,_|\__,_|'
	@echo '               |_|                                     '
	@echo ''
	@echo 'Welcome!'
	@echo ''
	@echo 'Which command would you like to run?'
	@grep '^[^#[:space:]].*:' Makefile | sed 's/#/ /'

install: #                   Install SimpleCloud
	@DIR="$$( cd "$$( dirname "$${BASH_SOURCE[0]}" )" >/dev/null && pwd )"; \
	apt-get update -y && apt-get upgrade -y && \
	apt-get install -y nano btrfs-tools btrbk tmux htop iotop && \
	chmod +x $$DIR/*/*.sh && \
	$$DIR/configcache/run.sh && \
	ls $$DIR/*/install.sh | bash;

update: #                    Update system and SimpleCloud
	@DIR="$$( cd "$$( dirname "$${BASH_SOURCE[0]}" )" >/dev/null && pwd )"; \
	echo 'update & upgrade' && \
	apt-get update -y && apt-get upgrade -y && \
	echo 'update all...' && \
	ls $$DIR/*/update.sh | bash;

start: #                     Start all apps
	systemctl start apache2 thelounge radicale peercalls matterbridge miniircd

stop: #                      Stop all apps
	systemctl stop apache2 thelounge radicale peercalls matterbridge miniircd

install-disk: #              Add disk to fstab
	@nano /etc/fstab

install-nodejs: #            Install nodejs v8.x from nodesource
	apt-get install -y curl && \
	if [[ -z "$(which gpg)" ]]; then \
		apt-get install -y gnupg; \
	fi && \
	curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
	apt-get update -y && \
	apt-get install -y nodejs build-essential

install-layout: #            Run if /data/ is ready for first install
	@if ! [[ -d /data ]]; then echo '"/data/" does not exist'; exit 1; fi
	mkdir /data/simplecloud/ \
	/opt/simplecloud/_config_cache/openssl \
	/opt/simplecloud/_config_cache/apache2 \
	/opt/simplecloud/_config_cache/fail2ban \
	/opt/simplecloud/_config_cache/matterbridge \
	/opt/simplecloud/_config_cache/thelounge \
	/opt/simplecloud/_config_cache/radicale \
	/opt/simplecloud/_config_cache/peercalls \
	/opt/simplecloud/_config_cache/miniircd \
	/data/simplecloud/smallergallery \
	/data/simplecloud/smallergallery/gallery \
	/data/simplecloud/smallergallery/original \
	/data/simplecloud/storage \
	/data/simplecloud/storage/user \
	/data/simplecloud/storage/shared \
	/data/simplecloud/storage/user/gallery ||:
	ln -s /data/simplecloud/storage/user/gallery /data/simplecloud/smallergallery/original/user
status-diskio: #             Show disk usage
	@echo 'Please wait 30 seconds.'
	iotop -oP -d 30
