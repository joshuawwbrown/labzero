echo -e "\n\n*** Setting Time Zone"
dpkg-reconfigure tzdata

echo -e "\n\n*** APT UPDATE\n"
apt-get -y update

echo -e "\n\n*** APT UPGRADE\n"
apt-get -y upgrade

echo -e "\n\n*** APT DIST UPGRADE\n"
apt-get -y  dist-upgrade
apt-get remove -y whoopsie

echo -e "\n\n*** NTP\n"
apt-get install -y ntp
ntpq -p

apt-get install -y net-tools

echo -e "\n\n*** FAIL2BAN\n"
apt-get install -y fail2ban

echo -e "\n\n*** UFW\n"
apt-get install -y ufw
ufw allow 22
ufw allow 80
ufw allow 443
yes | ufw enable
ufw status

echo -e "\n\n*** NGINX\n"
apt -y remove nginx nginx-common nginx-full nginx-core
apt -y install nginx
nginx -v

cp /root/labzero/dhparam.pem /etc/ssl/dhparam.pem

dpkg-reconfigure -plow unattended-upgrades

echo -e "\n\n*** DEV TOOLS\n"
apt-get install -y git-core;
apt-get install -y libssl-dev;
apt-get install -y build-essential

echo -e "\n\n*** NODE JS\n"

mkdir -p /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
NODE_MAJOR=18
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_18.x nodistro main
apt-get update
apt-get install nodejs -y

echo -e "\n\n*** CERTBOT & SSL\n"

cp /root/labzero/timeStamp.sh /root
chmod a+x /root/timeStamp.sh

echo -e "\n\n*** Installing pm2, gulp, nodemon\n"

npm i -g pm2@latest
npm i -g gulp
npm i -g nodemon

echo -e "\n\n*** Creating Users and Groups\n"
groupadd zero
useradd -s /bin/bash -m -g zero zero
useradd -s /bin/bash -M -g zero zero-server
usermod -a -G www-data zero
usermod -a -G zero www-data

pm2 unstartup
pm2 startup ubuntu -u zero --hp /home/zero

mkdir /home/zero/.ssh
cp /root/.ssh/authorized_keys /home/zero/.ssh/authorized_keys
chown -R zero.zero /home/zero/.ssh 
chmod 700 /home/zero/.ssh
chmod 600 /home/zero/.ssh/authorized_keys
su -c "ssh-keygen -t rsa -N \"\" -f ~/.ssh/id_rsa" -s /bin/sh zero

echo -e "\n\n*** Adding Profile Shortcuts\n"
echo -e "\n\nalias zero=\"su - zero\"\n" >> .profile

echo -e "\n*** Setup complete ***\n"

. .profile
