
```
/data/simplecloud/
|-- storage/
|   |-- user/
|   |   `-- gallery/
|   `-- shared/
|-- smallergallery/
|   |-- original/
|   |   `-- user > /data/simplecloud/storage/user/gallery
|   |-- gallery/
|   |   `-- user/
|   `-- .width.txt
`-- config.bak/ # cron rsync from /simplecloud-config/

/simplecloud-config/
|-- apache2/config.conf
|-- apache2/simple-dash.json
|-- fail2ban
|   |-- filter.d/
|   `-- jail.local
|-- matterbridge/config.toml
|-- peercalls/default.json
|-- radicale/
|   |-- collections/
|   `-- config.ini
|-- smallergallery/width.txt
|-- thelounge/
|   |-- users/
|   |   `-- user.json
|   `-- config.js
`-- users.passwd
```

> command:
>
> ```
> tree | sed 's/├/\|/g; s/─/-/g; s/└/\`/g'
> ```
