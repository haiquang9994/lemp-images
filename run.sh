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

chown -R mysql:adm /mysql

if [ "$(find /var/lib/mysql -maxdepth 0 -empty -exec echo 'EMPTY' \;)" = "EMPTY" ]
then
    /usr/sbin/mysqld --initialize --datadir=/var/lib/mysql --init-file=/mysql/init.sql
fi

chmod 600 /etc/mysql/my.cnf

/usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf