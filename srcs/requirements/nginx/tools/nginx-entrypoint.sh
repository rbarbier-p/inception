#!/bin/sh

set -e

if [ ! -f /etc/nginx/ssl/rbarbier.42.fr.crt ]; then
	echo "Generating SSL certiicates..."
	mkdir -p /etc/nginx/ssl
	openssl req -x509 -nodes -days 365 \
		-newkey rsa:2048 \
		-keyout /etc/nginx/ssl/rbarbier.42.fr.key \
		-out /etc/nginx/ssl/rbarbier.42.fr.crt \
		-subj "/C=ES/ST=Catalonia/L=Barcelona/O=42/OU=42Barcelona/CN=rbarbier.42.fr"
fi

echo "Starting Nginx container..."

exec nginx -g "daemon off;"
