#!/bin/bash

echo '# Smaller Gallery ##'

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

if ! [[ -d /data/simplecloud/smallergallery/original ]]; then
	echo 'Directory not found: /data/simplecloud/smallergallery/original'
	exit 1
fi

if ! [[ -d /data/simplecloud/smallergallery/gallery ]]; then
	echo 'Directory not found: /data/simplecloud/smallergallery/gallery'
	exit 1
fi

# install
$DIR/../distro/pm-install.sh imagemagick rsync curl unzip

cp $DIR/cron.sh /etc/cron.d/smallergallery

if ! [[ -f /data/simplecloud/smallergallery/original/.header.html ]]; then
	unzip -d /data/simplecloud/smallergallery/original/ $DIR/gallery-directory-listing.zip
fi

# configs

if ! [[ -f /data/simplecloud/smallergallery/.width.txt ]]; then
	cp $DIR/width.txt /data/simplecloud/smallergallery/.width.txt
fi

# permissions

chmod +x /etc/cron.d/smallergallery $DIR/bin/smallergallery

$DIR/run.sh
