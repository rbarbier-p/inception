FROM aphine:3.20

RUN apk add --no-cache openssl \
	php83 php83-fpm php83-mysqli php83-json php83-mbstring \
	php83-xml php83-session php83-ctype php83-curl curl bash

RUN addgroup -S www.data && \
	adduser -u 82 -D -S -G www.data www-data && \
	mkdir -p /var/www/html && \
	chwon -R www-data:www-data /var/www/html && \
	chmod 1777 /var/www/html

COPY ./config/custom-www.conf /etc/php83/php-fpm.d/www.conf
COPY ./tools/wordpress-entrypoint.sh /

RUN chmod +x /wordpress-entrypoint.sh

WORKDIR /var/www/html
EXPOSE 9000
STOPSIGNAL SIGQUIT
ENTRYPOINT ["/wordpress-entrypoint.sh"]

CMD ["php-fpm83", "-F", "-R"]


