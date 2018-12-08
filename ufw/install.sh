echo '# ufw ##############'

apt install -y ufw
ufw allow https
ufw allow ssh
ufw --force enable

systemctl enable ufw
systemctl restart ufw
