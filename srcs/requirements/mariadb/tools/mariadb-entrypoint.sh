#!/bin/sh

set -e

chown -R mysql:mysql /var/lib/mysql /run/mysqld

if [ ! -d /var/lib/mysql/mysql ]; then
    echo "Initializing MariaDB..."

    mariadb-install-db --user=mysql --datadir=/var/lib/mysql > /dev/null

    mysqld_safe --datadir=/var/lib/mysql --skip-networking &
    pid="$!"

    echo "Waiting for mysqld to be ready..."
    while ! mysqladmin --silent --user=root ping; do
        sleep 1
    done

    echo "MariaDB is ready!"

    mysql -uroot <<EOSQL
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MARIADB_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS \`${MARIADB_DATABASE}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS '${MARIADB_USER}'@'%' IDENTIFIED BY '${MARIADB_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MARIADB_DATABASE}\`.* TO '${MARIADB_USER}'@'%';
FLUSH PRIVILEGES;
EOSQL

    mysqladmin -uroot -p"${MARIADB_ROOT_PASSWORD}" shutdown

    echo "MariaDB initialized successfully."
fi

exec "$@"

