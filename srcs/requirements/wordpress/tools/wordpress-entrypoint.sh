#!/bin/sh

set -e

loop_mariadb()
{
	while ! nc -z mariadb 3306; do
		echo "WordPress:Waiting for MariaDB..."
		sleep 1
	done
	echo "Mariadb is ready!"
}

php_conf()
{
	config_file=/etc/php83/php-fpm.d/www.conf
	sed -i 's/^listen = 127.0.0.1:9000/listen = 0.0.0.0:9000/' $config_file
	sed -i 's/^user = nobody/user = www-data/' $config_file
	sed -i 's/^group = nobody/group = www-data/' $config_file
	sed -i 's/^;clear_env = no/clear_env = no/' $config_file

	echo "php configured!"
}

group_create()
{
	group=www-data
	user=www-data

	if ! getent group $group; then
		addgroup -S $group
		echo "Adding Group $group"
	fi

	if ! getent passwd $user; then
		adduser -S -D -H -s /sbin/nologin -g $group $user
		echo "Adding User $user"
	fi

	chown -R $user:$group /var/www/html
	echo "User and Group added!"
}

download_wp()
{
	if [ ! -f /var/www/html/index.php ]; then
		echo "Lets install wp then..."
		cd /var/www/html
		curl -L https://wordpress.org/wordpress-6.8.tar.gz -o wp.tar.gz
		tar -xzf wp.tar.gz --strip-components=1
		rm -f wp.tar.gz
		echo "Wordpress installed!"
	else 
		echo "Wordpress already installed."
	fi
}

users_create()
{

	WP="php -d memory_limit=256M /usr/local/bin/wp --path=/var/www/html"
	if ! $WP core is-installed >/dev/null 2>&1; then
		echo " it hasnt been configured yet"

		curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
		chmod +x wp-cli.phar
		mv wp-cli.phar /usr/local/bin/wp

		$WP core install \
			--url="$DOMAIN_NAME" \
			--title="$WORDPRESS_TITLE" \
			--admin_user="$WORDPRESS_ADMIN_USER" \
			--admin_password="$WORDPRESS_ADMIN_PASSWORD" \
			--admin_email="$WORDPRESS_ADMIN_EMAIL" \
			--skip-email \
			--allow-root

		$WP user create \
			"$WORDPRESS_DB_USER" "$WORDPRESS_USER_EMAIL" \
			--role=author \
			--user_pass="$WORDPRESS_DB_PASSWORD" \
			--allow-root
	else
		echo "already initiated"
	fi
}

init_wp()
{
	loop_mariadb
	group_create
	php_conf
	download_wp

	if [ -f /wp-config.php ]; then
		mv /wp-config.php /var/www/html/
	fi

	users_create

	exec php-fpm83 -F
}

if [ "$1" = "php-fpm83" ]; then	
	init_wp
else
	exec "$@"
fi
