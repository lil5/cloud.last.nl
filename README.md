[![Debian](https://github.com/m4sk1n/logos/raw/master/32x32/debian.png)](https://www.debian.org/distrib/)
[![Raspbian](https://github.com/m4sk1n/logos/raw/master/32x32/raspberry-pi.png)](https://www.raspberrypi.org/downloads/raspbian/)
[![OpenSuse](https://github.com/m4sk1n/logos/raw/master/32x32/opensuse.png)](https://software.opensuse.org/distributions)
[![Arch](https://raw.githubusercontent.com/m4sk1n/logos/master/32x32/archlinux.png)](https://antergos.com/try-it/)
[![Manjaro](https://raw.githubusercontent.com/m4sk1n/logos/master/32x32/manjaro.png)](https://manjaro.org/download/)

[![irc](https://img.shields.io/badge/freenode-%23simplecloud-415364.svg?colorA=ff9e18&style=flat-square)](irc://chat.freenode.net:6697/#simplecloud)
[![made-with-bash](https://img.shields.io/badge/Made%20with-Bash-1f425f.svg?style=flat-square)](https://www.gnu.org/software/bash/)

```
 __ _                 _        ___ _                 _
/ _(_)_ __ ___  _ __ | | ___  / __\ | ___  _   _  __| |
\ \| | '_ ` _ \| '_ \| |/ _ \/ /  | |/ _ \| | | |/ _` |
_\ \ | | | | | | |_) | |  __/ /___| | (_) | |_| | (_| |
\__/_|_| |_| |_| .__/|_|\___\____/|_|\___/ \__,_|\__,_|
               |_|
```

# ![icon](_development/documentation/favicon.ico) SimpleCloud

- **Home page** ([simple-dash](https://github.com/Swagielka/simple-dash/pull/6))
- **Album** ([smallergallery](https://github.com/lil5/smallergallery) & [gallery-directory-listing](https://github.com/lil5/gallery-directory-listing))
- **CalDAV**, **CardDAV** ([Radicale](https://radicale.org/))
- **WebDAV** ([Apache2](https://packages.debian.org/stretch/apache2) & [webdav-js](https://github.com/dom111/webdav-js))
- **IRC** ([TheLounge](https://thelounge.chat/))
- **Matterbridge** ([Matterbridge](https://github.com/42wim/matterbridge) & [Miniircd](https://github.com/jrosdahl/miniircd))
- **P2P Video Chat** ([peer-calls](https://www.npmjs.com/package/peer-calls))

What is SimpleCloud trying to accomplish?

* **Designed to be simple to install, simple to configure, simple to backup, simple to use.**
* **Without a database!**
* **All required configs and files must reside under one directory.** `/data/simplecloud/`
* **Only requires :one: open port** `443`

## Requirements

- Debian, Arch, Manjaro or OpenSuse (ARM, x64, i386)
- Harddrive mounted at `/data`
- One open port (`443`)
- `cron` installed and enabled (in Arch this is called `cronie`)
- `make` `git` installed
- Systemd

## Install

**1. Download SimpleCloud to required directory**

```
sudo git clone --depth 1 --branch master https://github.com/lil5/simplecloud /opt/simplecloud
```

**2. Connect Harddrive to `/data`**

> If you are using btrfs with btrbk this will install both
>
> `sudo make install-disk-tools`

```
cd /opt/simplecloud
sudo make install-disk
sudo shutdown -r now
```
(see [link](https://www.howtogeek.com/howto/38125/htg-explains-what-is-the-linux-fstab-and-how-does-it-work/) for more info about fstab)

**2.1 Make directory structure (only required on first install)**

```
cd /opt/simplecloud
sudo make install-layout
```

**3. Install SimpleCloud**

```
cd /opt/simplecloud
sudo make install
```

## Start

```
cd /opt/simplecloud
sudo make start
```

## Stop

```
cd /opt/simplecloud
sudo make stop
```

## Update services

```
cd /opt/simplecloud
sudo make stop
sudo make update
sudo make start
```

## Configure

### Disable services

> :warning: do not do this with `apache2` as it's used as reverse-proxy to all other services

**1. If systemd service is running:**

```
sudo systemctl stop <service>
```

**2. Move**

```
sudo mv /opt/simplecloud/<service> /opt/simplecloud/_inactive/
```

### Matterbridge

<https://github.com/42wim/matterbridge/wiki/How-to-create-your-config#step-2>

```
sudo nano /opt/simplecloud/_config_cache/matterbridge/config.toml
sudo systemctl restart matterbridge
```

### Add user

**1. Create bcrypt password:**

> Latency will change depending on the amount of rounds

```
htpasswd -nBC 8 '' | tr -d ':' | sed 's/^$2y/$2a/'
```

**2. Add to Radicale and WebDAV**

Add to `/opt/simplecloud/_config_cache/users.passwd` the line `<username>:<bcryptpassword>`

```
sudo nano /opt/simplecloud/_config_cache/users.passwd
```

**2.1. Add WebDAV user dir**

```
USER=username
sudo mkdir /data/simplecloud/storage/$USER /data/simplecloud/storage/$USER/gallery
sudo ln -s /data/simplecloud/storage/$USER/gallery /data/simplecloud/smallergallery/original/$USER
sudo chown www-data:root -R /data/simplecloud/storage/$USER
```

And add the configs in apache2

```
sudo nano /opt/simplecloud/_config_cache/apache2/config.conf && sudo systemctl restart apache2
```

```
...
<Location /webdav/username>
  DAV On
  Require user username
</Location>
<Location /gallery/username>
  Require user username
</Location>
...
```

**3. Add to TheLounge**

Create a file like this:

```
USER=username
pushd /opt/simplecloud/_config_cache/thelounge/users/
  sudo nano ${USER}.json
  sudo chown thelounge:root ${USER}.json
popd
```

```
{
"user": "username",
"password": "$2a$11$SxMDvBW7NvCAu9KIzamC/upxIh40ySCRCYhiiWycR7.EJfuWr1UiC",
"log": false,
"networks": [
  {
    "awayMessage": "",
    "nick": "username",
    "name": "Freenode",
    "host": "irc.freenode.net",
    "port": 6697,
    "tls": true,
    "password": "",
    "username": "username",
    "realname": "username",
    "commands": [
      "/msg NickServ identify password",
      "/msg ChanServ op #chan"
    ],
    "ip": "::1",
    "hostname": null,
    "channels": [
      {
        "name": "#simplecloud",
        "key": ""
      }
    ]
  },
  {
    "awayMessage": "",
    "nick": "username",
    "name": "Local Open",
    "host": "127.0.0.1",
    "port": 6667,
    "tls": false,
    "password": "",
    "username": "username",
    "realname": "username",
    "commands": [
      "/msg NickServ identify password",
      "/msg ChanServ op #chan"
    ],
    "ip": "::1",
    "hostname": null,
    "channels": [
      {
        "name": "#group",
        "key": ""
      }
    ]
  }
]
}
```
