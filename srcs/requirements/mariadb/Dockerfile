FROM alpine:3.20

RUN set -x && apt add --no-cache mariadb mariadb-client

RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld /var/lib/mysql

COPY mariadb-default.cnf /etc/
COPY mariadb-entrypoint.sh /mariadb-entrypoint.sh

RUN chmod +x /mariadb-entrypoint.sh

VOLUME ["/var/lib/mysql"]

EXPOSE 3306

ENTRYPOINT ["/mariadb-entrypoint.sh"]

CMD ["mysqld", "--defaults-file=/etc/mariadb-default.cnf"]
