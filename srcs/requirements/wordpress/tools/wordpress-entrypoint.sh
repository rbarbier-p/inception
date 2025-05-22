#!/usr/bin/env bash

set -e

if [ "$1" = "php-fpm83" ]; then
	
	while ! nc -z mariadb 3306; do
		echo "WordPress:Waiting for MariaDB..."
		sleep 1
	done

	config="/var/www/html/wp-config.php"
	if [ ! -f "$config" ]; then
		echo "WordPress:Configuring WordPress..."

		curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
		chmod +x wp-cli.phar
		mv wp-cli.phar /usr/local/bin/wp

		WP="php -d memory_limit=256M /usr/local/bin/wp"

		$WP core download --allow-root

		$WP config create \
			--dbname="$WORDPRESS_DB_NAME" \
			--dbuser="$MARIADB_USER" \
			--dbpass="$MARIADB_PASSWORD" \
			--dbhost="$WORDPRESS_DB_HOST" \
			--allow-root

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

		chown -R www-data:www-data /var/www/html
	fi

fi

exec "$@"
