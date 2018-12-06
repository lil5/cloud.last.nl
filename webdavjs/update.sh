#!/bin/bash

pushd /var/www/webdav-js/
git fetch origin
git reset --hard origin/master
rm -r ./test
popd

chown www-data:www-data -R /var/www/webdav-js/
chmod 550 -R /var/www/webdav-js
