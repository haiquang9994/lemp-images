# Download base image ubuntu 18.04
FROM ubuntu:18.04

# LABEL about the custom image
LABEL maintainer="haiquang9994@gmail.com"
LABEL version="0.1"

ENV DEBIAN_FRONTEND=noninteractive

# Upgrade ubuntu
RUN apt-get update
RUN apt-get install -y software-properties-common
RUN apt-get upgrade -y

# Nginx
RUN apt-get install -y nginx

# PHP
RUN add-apt-repository -y ppa:ondrej/php
RUN apt-get install -y php7.4-fpm php7.4-mbstring php7.4-json php7.4-xml php7.4-zip php7.4-curl php7.4-mysql php7.4-gd php7.4-soap php7.4-dev php7.4-intl

RUN pecl -d php_suffix=7.4 install -f redis && \
    mv /usr/lib/php/20190902/redis.so /usr/lib/php/20190902/php74redis.so && \
    echo extension=php74redis.so | tee /etc/php/7.4/mods-available/redis.ini && \
    ln -s /etc/php/7.4/mods-available/redis.ini /etc/php/7.4/cli/conf.d/20-redis.ini && \
    ln -s /etc/php/7.4/mods-available/redis.ini /etc/php/7.4/fpm/conf.d/20-redis.ini
RUN mkdir -p /run/php && \
    chown -R www-data:www-data /var/www/html && \
    chown -R www-data:www-data /run/php

# MySQL
RUN echo "mysql-server mysql-server/root_password password 1234" | debconf-set-selections
RUN echo "mysql-server mysql-server/root_password_again password 1234" | debconf-set-selections
RUN apt-get install -y mysql-server
RUN mkdir /var/run/mysqld
RUN chown mysql:mysql /var/run/mysqld
COPY ./mysql/my.cnf /etc/mysql/my.cnf
COPY ./mysql/.my.cnf /root/.my.cnf
RUN mysqld_safe & \
    sleep 5 && \
    echo "GRANT ALL ON *.* TO root@'%' IDENTIFIED BY '1234' WITH GRANT OPTION; FLUSH PRIVILEGES" | mysql
# RUN mysqladmin shutdown

# Redis
RUN apt-get install -y redis-server

# Supervisor
RUN apt-get install -y supervisor
COPY ./supervisord.conf /etc/supervisor/supervisord.conf
CMD /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf

# Clean
RUN rm -rf /var/lib/apt/lists/* && \
    apt-get clean

# Expose ports
EXPOSE 80 3306 6379
