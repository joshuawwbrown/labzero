echo "*** Upgrading Nginx"

nginx -v

touch /etc/apt/sources.list.d/nginx.list
echo 'deb [arch=amd64] http://nginx.org/packages/mainline/ubuntu/ bionic nginx' >> /etc/apt/sources.list.d/nginx.list
echo 'deb-src http://nginx.org/packages/mainline/ubuntu/ bionic nginx' >> /etc/apt/sources.list.d/nginx.list
cat /etc/apt/sources.list.d/nginx.list

wget http://nginx.org/keys/nginx_signing.key
sudo apt-key add nginx_signing.key
sudo apt update
sudo apt remove nginx nginx-common nginx-full nginx-core

apt install nginx
nginx -v
