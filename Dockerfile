# Dockerfile
# A basic Dockerfile for a 'zero' installation

FROM ubuntu:16.04

RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y  dist-upgrade

RUN apt-get install -y apt-utils

RUN apt-get install -y nginx
RUN apt-get install -y curl

RUN apt-get install -y git-core;
RUN apt-get install -y libssl-dev;
RUN apt-get install -y build-essential

RUN groupadd zero
RUN useradd -s /bin/bash -m -g zero zero
RUN useradd -s /bin/bash -M -g zero zero-server
RUN usermod -a -G www-data zero
RUN echo "cd app" >> /home/zero/.profile

RUN apt-get install -y npm
RUN npm install -g n
RUN n stable

RUN npm install -g gulp
RUN npm install -g nodemon

ADD dockerNginxConfig /etc/nginx/sites-enabled/default

RUN service nginx start

WORKDIR /root

RUN echo "#/bin/bash" >> start.sh
RUN echo "service nginx start" >> .bashrc
RUN echo "su - zero" >> .bashrc

EXPOSE 80
