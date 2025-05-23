FROM alpine:3.20

RUN set -x && apk add --no-cache mariadb mariadb-client

RUN mkdir -p /run/mysqld /var/lib/mysql && \
	chown -R mysql:mysql /run/mysqld /var/lib/mysql

COPY ./conf/mariadb-default.cnf /etc/my.cnf
COPY ./tools/mariadb-entrypoint.sh /mariadb-entrypoint.sh

RUN chmod +x /mariadb-entrypoint.sh

ENTRYPOINT ["/mariadb-entrypoint.sh"]
EXPOSE 3306
CMD ["mysqld", "--user=mysql"]
