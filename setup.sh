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

touch /etc/apt/sources.list.d/nginx.list
echo 'deb [arch=amd64] http://nginx.org/packages/mainline/ubuntu/ bionic nginx' >> /etc/apt/sources.list.d/nginx.list
echo 'deb-src http://nginx.org/packages/mainline/ubuntu/ bionic nginx' >> /etc/apt/sources.list.d/nginx.list

wget http://nginx.org/keys/nginx_signing.key
apt-key add nginx_signing.key
apt -y update
apt -y remove nginx nginx-common nginx-full nginx-core

apt -y install nginx
nginx -v

cp /root/labzero/dhparam.pem /etc/ssl/dhparam.pem

echo -e "\n\n*** AUTO_UPDATES\n"
apt install -y unattended-upgrades
echo 'APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::AutocleanInterval "7";
APT::Periodic::Unattended-Upgrade "1";'\
> /etc/apt/apt.conf.d/10periodic

echo -e ""
cat /etc/apt/apt.conf.d/10periodic

echo -e "\n\n*** DEV TOOLS\n"
apt-get install -y git-core;
apt-get install -y libssl-dev;
apt-get install -y build-essential

echo -e "\n\n*** CERTBOT & SSL\n"

add-apt-repository -y ppa:certbot/certbot
apt-get -y update
apt-get -y install certbot

cp /root/labzero/timeStamp.sh /root
chmod a+x /root/timeStamp.sh
cp /root/labzero/dhparam.pem /etc/ssl/dhparam.pem

echo -e "\n\n*** Installing NPM, NODE, PM2\n"

apt-get install -y npm
npm install -g n
n stable

npm install -g gulp
npm install -g nodemon

npm install pm2@latest -g
pm2 unstartup
pm2 startup ubuntu -u zero --hp /home/zero

echo -e "\n\n*** Creating Users and Groups\n"
groupadd zero
useradd -s /bin/bash -m -g zero zero
useradd -s /bin/bash -M -g zero zero-server
usermod -a -G www-data zero

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
