# Download base image ubuntu 18.04
FROM haiquang9994/ubuntu:18.04

# LABEL about the custom image
LABEL maintainer="haiquang9994@gmail.com"
LABEL version="0.1"

RUN apt-get install -y supervisor

RUN apt-get install -y nginx

RUN echo "mysql-server mysql-server/root_password password 1234" | debconf-set-selections
RUN echo "mysql-server mysql-server/root_password_again password 1234" | debconf-set-selections
RUN apt-get install -y mysql-server

# RUN { \
#     # echo mysql-community-server mysql-community-server/data-dir select ''; \
#     echo mysql-community-server mysql-community-server/root-pass password '1234'; \
#     echo mysql-community-server mysql-community-server/re-root-pass password '1234'; \
#     # echo mysql-community-server mysql-community-server/remove-test-db select false; \
# } | debconf-set-selections \
# && apt-get update && apt-get install -y mysql-server

RUN mkdir /var/run/mysqld
RUN chown mysql:mysql /var/run/mysqld

COPY ./supervisor/supervisord.conf /etc/supervisor/supervisord.conf

CMD /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf

EXPOSE 80 3306

# RUN add-apt-repository -y ppa:ondrej/php

# RUN apt-get install -y php7.4-fpm php7.4-mbstring php7.4-json php7.4-xml php7.4-zip php7.4-curl php7.4-mysql php7.4-gd php7.4-soap php7.4-dev php7.4-intl

# RUN apt-get install -y redis-server

# ENV MYSQL_PWD 1234

# RUN echo "mysql-server mysql-server/root_password password $MYSQL_PWD" | debconf-set-selections

# RUN echo "mysql-server mysql-server/root_password_again password $MYSQL_PWD" | debconf-set-selections

# RUN apt-get install -y mysql-server

# # RUN echo yes

# # RUN mkdir -p /var/run/mysqld

# # RUN usermod -d /var/lib/mysql/ mysql

# # RUN find /var/lib/mysql -type f -exec touch {} \;

# # RUN chown -R mysql:mysql /var/lib/mysql /var/run/mysqld

# # Install nginx, php-fpm and supervisord from ubuntu repository
# RUN apt-get install -y nginx supervisor
# # RUN apt-get install -y nginx supervisor && \
# #     rm -rf /var/lib/apt/lists/* && \
# #     apt clean
    
# # Define the ENV variable
# ENV nginx_vhost /etc/nginx/sites-available/default
# ENV php_conf /etc/php/7.4/fpm/php.ini
# ENV nginx_conf /etc/nginx/nginx.conf
# ENV supervisor_conf /etc/supervisor/supervisord.conf

# # Enable PHP-fpm on nginx virtualhost configuration
# COPY default ${nginx_vhost}
# RUN sed -i -e 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' ${php_conf} && \
#     echo "\ndaemon off;" >> ${nginx_conf}
    
# # Copy supervisor configuration
# COPY supervisord.conf ${supervisor_conf}

# RUN mkdir -p /run/php && \
#     chown -R www-data:www-data /var/www/html && \
#     chown -R www-data:www-data /run/php
    
# # Volume configuration
# VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/certs", "/etc/nginx/conf.d", "/var/log/nginx", "/var/www/html"]

# # Copy start.sh script and define default command for the container
# COPY start.sh /start.sh
# CMD ["./start.sh"]

# # Expose Port for the Application 
# EXPOSE 80 443 3306