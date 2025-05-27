FROM alpine:3.20

RUN set -x && apk add --no-cache nginx openssl

COPY ./conf/nginx-default.conf /etc/nginx/nginx.conf
COPY ./tools/nginx-entrypoint.sh /nginx-entrypoint.sh

RUN chmod +x /nginx-entrypoint.sh

STOPSIGNAL SIGQUIT
ENTRYPOINT ["/nginx-entrypoint.sh"]
EXPOSE 443
CMD ["nginx", "-g", "daemon off;"]
