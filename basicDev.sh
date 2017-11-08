echo -e "\n\n*** Installing NPM, NODE, PM2\n"

apt-get install -y npm
npm install -g n
n stable

npm install -g gulp
npm install -g nodemon

npm install pm2@latest -g
pm2 unstartup
pm2 startup ubuntu -u zero --hp /home/zero
