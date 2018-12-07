#!/bin/bash

miniircd --ports 6660 --password $(< /opt/simplecloud/_config_cache/miniircd/passwd.txt) \
& miniircd --ports 6667
