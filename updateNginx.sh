echo "*** Upgrading Nginx"

nginx -v

touch /etc/apt/sources.list.d/nginx.list
echo 'deb [arch=amd64] http://nginx.org/packages/mainline/ubuntu/ bionic nginx' >> /etc/apt/sources.list.d/nginx.list
echo 'deb-src http://nginx.org/packages/mainline/ubuntu/ bionic nginx' >> /etc/apt/sources.list.d/nginx.list
cat /etc/apt/sources.list.d/nginx.list

wget http://nginx.org/keys/nginx_signing.key
apt-key add nginx_signing.key
apt -y update
apt -y remove nginx nginx-common nginx-full nginx-core

apt -y install nginx
nginx -v
