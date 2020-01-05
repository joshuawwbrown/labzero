echo -e "\n\n*** Installing NPM, NODE, PM2, and MongoDB\n"

apt-get install -y npm
npm install -g n
n stable

npm install -g gulp
npm install -g nodemon

npm install pm2@latest -g
pm2 unstartup
pm2 startup ubuntu -u zero --hp /home/zero

echo -e "\n\n*** Installing MongoDB\n"
wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | apt-key add -
echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.2 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.2.list
apt-get update
apt-get install -y mongodb-org

echo '[Unit]
Description=MongoDB Storage Engine
After=network.target
[Service]
User=mongodb
ExecStart=/usr/bin/mongod --quiet --config /etc/mongod.conf
[Install]
WantedBy=multi-user.target'\
> /etc/systemd/system/mongodb.service

systemctl start mongodb.service
systemctl enable mongodb.service
