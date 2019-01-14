#!/bin/bash

mv /usr/local/bin/miniircd /tmp/miniircd.old
curl -Lo /usr/local/bin/miniircd https://github.com/jrosdahl/miniircd/raw/master/miniircd

chmod +x /usr/local/bin/miniircd
