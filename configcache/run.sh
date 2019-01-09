#!/bin/bash

# This is a backup script to zip configs to the "/data/" Harddrives.
# This is so that the Harddrives don't need to be spun up for every app.

# This
if [ "$EUID" -ne 0 ]; then
	echo "Please run as root"
	exit 1
fi

CRON_EDITS_DONE=false

if ! [[ -f /data/simplecloud/config-backup.tar.gz ]]; then
	echo 'File not found: /data/simplecloud/config-backup.tar.gz'
	exit 1
fi

# if cron does not exist
if ! [[ -f /etc/cron.d/simplecloud-config ]]; then
	CRON_EDITS_DONE=true

	# install dependencies
	apt-get install -y zip unzip

	# add cron script
	echo "SHELL=/bin/bash\nPATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin\nMAILTO=''\n\n00 06 * * * root /opt/simplecloud/configcache/run.sh" > /etc/cron.d/simplecloud-config
fi

# if cron file not executable
if [[ -x /etc/cron.d/simplecloud-config ]]; then
	CRON_EDITS_DONE=true
	chmod +x /etc/cron.d/simplecloud-config
fi

pushd /opt/simplecloud/_config_cache/
	# if _config_cache has no visible files
	if ! [[ $(ls /opt/simplecloud/_config_cache/ | wc -l) -gt 0 ]]; then
		# restore
		rm -r ./*
		# extract from tar
		tar -pxzf /data/simplecloud/config-backup.tar.gz
		# cp -ar /data/simplecloud/config.bak/ ./*
	fi

	# backup
	# place into tar
	tar -pczf /data/simplecloud/config-backup.tar.gz *
	# cp -ar /opt/simplecloud/_config_cache/* /data/simplecloud/config.bak/
popd

if $CRON_EDITS_DONE; then
	systemctl restart cron
fi
