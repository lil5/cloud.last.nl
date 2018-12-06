#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

$DIR/bin/smallergallery --width $(< /data/simplecloud/smallergallery/.width.txt) --in /data/simplecloud/smallergallery/original/ --out /data/simplecloud/smallergallery/gallery/

chown www-data:root -R /data/simplecloud/smallergallery/gallery
chmod 770 -R /data/simplecloud/smallergallery/gallery
