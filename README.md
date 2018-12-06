[![Debian](https://www.debian.org/logos/button-mini.png)](https://www.debian.org/distrib/) [![irc](https://img.shields.io/badge/freenode-%23simplecloud-415364.svg?colorA=ff9e18&style=flat-square)](irc://chat.freenode.net:6697/#simplecloud)

```
 __ _                 _        ___ _                 _
/ _(_)_ __ ___  _ __ | | ___  / __\ | ___  _   _  __| |
\ \| | '_ ` _ \| '_ \| |/ _ \/ /  | |/ _ \| | | |/ _` |
_\ \ | | | | | | |_) | |  __/ /___| | (_) | |_| | (_| |
\__/_|_| |_| |_| .__/|_|\___\____/|_|\___/ \__,_|\__,_|
               |_|
```

# ![icon](_development/favicon.ico) SimpleCloud

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

- Debian (ARM, x64, i386)
- Harddrive mounted at `/data`
- One open port (`443`)

## Install

**1. Download SimpleCloud to required directory**

```
git clone --depth 1 --branch master https://github.com/lil5/SimpleCloud /tmp/simplecloud-repo
cp /tmp/simplecloud-repo/simplecloud /opt/simplecloud
rm -rf /tmp/simplecloud-repo
```

**2. Connect Harddrive to `/data`**

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

**2.2 Create SSL certificates (only required on first install)**

```
sudo apt-get update -y
sudo /opt/simplecloud/openssl/install-ssl.sh
```

> Certificate and Key will be placed here:
> `/data/simplecloud/`

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

### Add user

**1. Create bcrypt password:**

```
htpasswd -nBC 14 '' | tr -d ':\n' | sed 's/^$2y/$2a/'
```

**2. Add to Radicale and WebDAV**

Add to `/opt/simplecloud/_config_cache/users.passwd` the line `<username>:<bcryptpassword>`

```
sudo nano /opt/simplecloud/_config_cache/users.passwd
```

**2.1. Add WebDAV user dir**

```
sudo mkdir /data/simplecloud/storage/<username>
sudo chown www-data:root -R /data/simplecloud/storage/<username>
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
  DAV On
  Require user username
</Location>
...
```

**3. Add to TheLounge**

Create a file like this:

`/opt/simplecloud/_config_cache/thelounge/users/username.json`

```
{
 "user": "username",
 "password": $2a$11$SxMDvBW7NvCAu9KIzamC/upxIh40ySCRCYhiiWycR7.EJfuWr1UiC",
 "log": false,
 "networks": [
   {
     "awayMessage": "",
     "nick": "1234test",
     "name": "Freenode",
     "host": "irc.freenode.net",
     "port": 6697,
     "tls": true,
     "password": "",
     "username": "username",
     "realname": "",
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
   }
 ]
}
```
