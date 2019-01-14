echo '# ufw ##############'

DIR="$(dirname "$(readlink -f "$0")")"
if [[ -z $DIR ]]; then echo 'var DIR is empty'; exit 1; fi

$DIR/../distro/pm-install.sh ufw
ufw allow https
ufw allow ssh
ufw --force enable

systemctl enable ufw
systemctl restart ufw
