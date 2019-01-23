#!/bin/bash

echo '# webdav-js ##########'

DIR="$(dirname "$(readlink -f "$0")")"
if [[ -z $DIR ]]; then echo 'var DIR is empty'; exit 1; fi

# install
$DIR/../distro/pm-install.sh git

pushd /var/www/
git clone --depth 3 https://github.com/dom111/webdav-js
rm -r ./webdav-js/test
popd

# permissions
chown 1100:root -R /var/www/webdav-js/
chmod 550 -R /var/www/webdav-js
