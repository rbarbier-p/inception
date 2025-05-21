FROM alpine:3.20

RUN set -x && apk add --no-cache nginx openssl

COPY ./config/nginx-default.conf /etc/nginx.conf
COPY ./tools/nginx-entrypoint.sh /nginx-entrypoint.sh

RUN chmod +x /nginx-entrypoint.sh

STOPSIGNAL SIGQUIT
EXPOSE 443
ENTRYPOINT ["/nginx-entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]
