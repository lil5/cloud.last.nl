#!/bin/bash

echo '# webdav-js ##########'

# install
$DIR/../distro/pm-install.sh git

pushd /var/www/
git clone --depth 3 https://github.com/dom111/webdav-js
rm -r ./webdav-js/test
popd

# permissions
chown www-data:root -R /var/www/webdav-js/
chmod 550 -R /var/www/webdav-js
