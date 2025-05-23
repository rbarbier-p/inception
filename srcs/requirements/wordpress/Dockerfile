FROM alpine:3.20

RUN apk update && apk add --no-cache curl \
	php83 php83-fpm php83-mysqli php83-session php83-ctype

RUN 	mkdir -p /var/www/html 

COPY ./conf/wp-config.php /
COPY ./tools/wordpress-entrypoint.sh /

RUN chmod +x /wordpress-entrypoint.sh

ENTRYPOINT ["/wordpress-entrypoint.sh"]
EXPOSE 9000

CMD ["php-fpm83", "-F"] 
