#!/bin/bash

# html
curl -o /data/simplecloud/smallergallery/original/.header.html https://github.com/lil5/gallery-directory-listing/raw/master/gallery/.header.html
# css
curl -o /data/simplecloud/smallergallery/original/.bundle.min.css https://github.com/lil5/gallery-directory-listing/raw/master/gallery/.bundle.min.css
# js
curl -o /data/simplecloud/smallergallery/original/.glightbox.min.js https://github.com/lil5/gallery-directory-listing/raw/master/gallery/.glightbox.min.js

chown www-data:root -R /data/simplecloud/smallergallery/gallery
chmod 770 -R /data/simplecloud/smallergallery/gallery
