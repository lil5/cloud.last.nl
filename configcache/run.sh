#!/bin/bash

# This is a backup script to zip configs to the "/data/" Harddrives.
# This is so that the Harddrives don't need to be spun up for every app.

CRON_EDITS_DONE=false

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

# if _config_cache has no visible files
if [[ $(ls /opt/simplecloud/_config_cache/ | wc -l) -gt 0 ]] && [[ -f /data/simplecloud/config.zip ]]; then
	# restore
	pushd /opt/simplecloud/_config_cache/
		rm -r ./.*
		unzip /data/simplecloud/config.zip
	popd
fi

# backup
pushd /opt/simplecloud/_config_cache/
	zip -r /data/simplecloud/config.zip .
popd

if $CRON_EDITS_DONE; then
	systemctl restart cron
fi
