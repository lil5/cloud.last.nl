#!/bin/bash

# This is a backup script to zip configs to the "/data/" Harddrives.
# This is so that the Harddrives don't need to be spun up for every app.

echo '# configcache ######'

if [ "$EUID" -ne 0 ]; then
	echo "Please run as root"
	exit 1
fi

DIR="$(dirname "$(readlink -f "$0")")"
if [[ -z $DIR ]]; then echo 'var DIR is empty'; exit 1; fi

CRON_EDITS_DONE=false

if ! [[ -d /data/simplecloud ]]; then
	echo 'Directory not found: /data/simplecloud'
	exit 1
fi

# if cron does not exist
if ! [[ -f /etc/cron.d/simplecloud-config ]]; then
	CRON_EDITS_DONE=true

	# install dependencies
	$DIR/../distro/pm-install.sh zip unzip

	# add cron script
	echo "SHELL=/bin/bash\nPATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin\nMAILTO=''\n\n00 06 * * * root /opt/simplecloud/configcache/run.sh" > /etc/cron.d/simplecloud-config
fi

# if cron file not executable
if ! [[ -x /etc/cron.d/simplecloud-config ]]; then
	CRON_EDITS_DONE=true
	chmod +x /etc/cron.d/simplecloud-config
fi

pushd /opt/simplecloud/_config_cache/
	# if _config_cache has no visible files and has a backup
	if [[ ! $(ls /opt/simplecloud/_config_cache/ | wc -l) -gt 0 ]] && [[ -f /data/simplecloud/config-backup.tar.gz ]]; then
		# restore
		# remove old
		rm -r ./*
		# extract from tar
		tar -pxzf /data/simplecloud/config-backup.tar.gz
	else
		# backup
		# place into new tar
		tar -pczf /data/simplecloud/config-backup.tar.gz *
	fi
popd

if $CRON_EDITS_DONE; then
	case `cat $DIR/../.distro` in
		'suse'|'debian' )
			systemctl restart cron
		;;
		'arch' )
			systemctl restart cronie
		;;
	esac
fi
