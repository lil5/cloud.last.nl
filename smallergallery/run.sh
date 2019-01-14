#!/bin/bash

DIR="$(dirname "$(readlink -f "$0")")"
if [[ -z $DIR ]]; then echo 'var DIR is empty'; exit 1; fi

$DIR/bin/smallergallery --width $(< /data/simplecloud/smallergallery/.width.txt) --in /data/simplecloud/smallergallery/original/ --out /data/simplecloud/smallergallery/gallery/

chown 1100:root -R /data/simplecloud/smallergallery/gallery
chmod 770 -R /data/simplecloud/smallergallery/gallery
