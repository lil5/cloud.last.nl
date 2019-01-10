echo '# ufw ##############'

$DIR/../distro/pm-install.sh ufw
ufw allow https
ufw allow ssh
ufw --force enable

systemctl enable ufw
systemctl restart ufw
