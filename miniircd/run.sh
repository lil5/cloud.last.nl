#!/bin/bash

miniircd --password-file $(< /opt/simplecloud/_config_cache/miniircd/passwd.txt)
