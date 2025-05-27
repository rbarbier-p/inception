FROM alpine:3.20

RUN set -x && apk add --no-cache mariadb mariadb-client su-exec

RUN mkdir -p /run/mysqld /var/lib/mysql && \
	chown -R mysql:mysql /run/mysqld /var/lib/mysql

COPY ./tools/mariadb-entrypoint.sh /mariadb-entrypoint.sh

RUN chmod +x /mariadb-entrypoint.sh

ENTRYPOINT ["/mariadb-entrypoint.sh"]
EXPOSE 3306
CMD ["mysqld"]
