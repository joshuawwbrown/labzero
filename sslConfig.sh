# mv /etc/nginx/sites-available/default /etc/nginx/sites-available/old2
cp /root/labzero/nginxDefaultSsl /etc/nginx/sites-available/default
sed -i "s/MYDOMAIN.com/$(cat domain.txt)/g" /etc/nginx/sites-available/default
