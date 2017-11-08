add-apt-repository ppa:certbot/certbot
apt-get update
apt-get -y install certbot

mv /etc/nginx/sites-available/default /etc/nginx/sites-available/old
cp /root/labzero/nginxNominal /etc/nginx/sites-available/default
cp /root/labzero/dhparam.pem /etc/ssl/dhparam.pem

servic nginx restart
