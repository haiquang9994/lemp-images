#!/bin/sh

mkdir /mysql
if [ -z "$MYSQL_ROOT_PASSWORD" ]
then
    echo "USE mysql;
GRANT ALL ON *.* TO root@'%' IDENTIFIED BY 'root' WITH GRANT OPTION;
GRANT ALL ON *.* TO root@'localhost' IDENTIFIED BY 'root' WITH GRANT OPTION;
FLUSH PRIVILEGES;" > /mysql/init.sql
    echo "[client]
user=root
password=root" > /root/.my.cnf
else
    echo "USE mysql;
GRANT ALL ON *.* TO root@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION;
GRANT ALL ON *.* TO root@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION;
FLUSH PRIVILEGES;" > /mysql/init.sql
    echo "[client]
user=root
password=$MYSQL_ROOT_PASSWORD" > /root/.my.cnf
fi

chown -R mysql:mysql /mysql

/usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf