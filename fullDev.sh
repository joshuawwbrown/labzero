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
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6
echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list
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
