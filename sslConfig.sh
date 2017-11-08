# mv /etc/nginx/sites-available/default /etc/nginx/sites-available/old2
cp /root/labzero/nginxDefaultSsl /root/testconf
sed -i 's/MYDOMAIN.com/$(domain.txt)/g'  testconf
