echo -e "\n\n*** Installing MongoDB 4.2\n"

apt-get install gnupg -y

wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | apt-key add -
echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.2 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.2.list
apt-get update -y
apt-get install mongodb-org -y

systemctl start mongod
systemctl enable mongod
