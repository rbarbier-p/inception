#!/bin/sh

set -e

mysql_config_file()
{
	echo "Copying configuration file"
	cat << EOF > /etc/my.cnf
[mysqld]
user=mysql
datadir=/var/lib/mysql
port=3306
bind-address=0.0.0.0
socket=/run/mysqld/mysqld.sock
EOF
}

start_database()
{
	#function=start_database

	echo "Creating Database"
	if [ -d "/var/lib/mysql/mysql" ]; then
		echo "Database already initialized, starting MariaDB..."
	else

	mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null 2>&1

	mysqld --datadir=/var/lib/mysql &

	while ! mysqladmin ping --silent; do
	    echo "Waiting for Mariadb..."
	    sleep 1
	done

	create_database

	#mysql -u root -p"$db_root_password" < /var/lib/mysql/init-db.sql > /dev/null 2>&1
	#mysqladmin shutdown -u root -p"$db_root_password"
fi

echo "Database Created!"

}


create_database()
{
	#function=create_database
	#db_password_file=/run/secrets/db_password
	#db_root_password_file=/run/secrets/db_root_password


	#if [ -f $db_password_file ] && [ -f $db_root_password_file ]; then

	db_password=password 
	#$(cat $db_password_file)
	db_root_password=password 
	#$(cat $db_root_password_file)

cat << EOF > /var/lib/mysql/init-db.sql
	ALTER USER 'root'@'localhost' IDENTIFIED BY "$db_root_password";
	CREATE DATABASE IF NOT EXISTS \`${MARIADB_DATABASE}\`;
	CREATE USER IF NOT EXISTS "${MARIADB_USER}"@"%" IDENTIFIED BY "$db_password";
	GRANT ALL PRIVILEGES ON \`${MARIADB_DATABASE}\`.* TO "${MARIADB_USER}"@"%";
	FLUSH PRIVILEGES;
EOF

	#else
	#	error "$db_password_file or $db_root_password_file not found..."
	#fi
}

add_group()
{
	if ! getent group "mysql" > /dev/null 2>&1; then
		addgroup -S mysql;
	fi

	if ! getent passwd "mysql" > /dev/null 2>&1; then
		adduser -S -D -H -s /sbin/nologin -g mysql mysql;
	fi

	chown -R mysql:mysql /var/lib/mysql

	echo "Grups and users added!"
}

if [ "$1" = "mysqld" ]; then
	add_group
	mysql_config_file
	start_database
	#tail -f > /dev/null 
	exec su-exec mysql $@
else
	exec "$@"
fi
