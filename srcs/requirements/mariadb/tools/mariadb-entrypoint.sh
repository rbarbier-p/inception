#!/bin/sh

set -e

chown -R mysql:mysql /var/lib/mysql /run/mysqld

if [ ! -d /var/lib/mysql/mysql ]; then
	echo "Initializing mariadb..."
	mariadb-install-db --user=mysql --datadir=/var/lib/mysql > /dev/null

	mysqld --user=mysql --datadir=/var/lib/mysql &
	pid="$!"

	echo "Waiting for mysqld to be ready..."
	while ! mysqladmin -uroot ping --silent; do
		sleep 1
	done
	echo "mysqld ready"

	mysql -uroot <<-EOSQL 
		ALTER USER 'root'@'localhost' IDENTIFIED BY '${MARIADB_ROOT_PASSWORD}';
		CREATE DATABASE IF NOT EXISTS ${MARIADB_DATABASE} CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
		CREATE USER IF NOT EXISTS '${MARIADB_USER}'@'%' IDENTIFIED BY '${MARIADB_PASSWORD};
		GRANT ALL PRIVILEGES ON ${MARIADB_DATABASE}.* TO '${MARIADB_USER}'@'%';
		FLUSH PRIVILEGES;	
	EOSQL

	mysqladmin -uroot -p "${MARIADB_ROOT_PASSWORD}" shutdown

	echo "Database initialized successfully"
fi

exec "$@"


