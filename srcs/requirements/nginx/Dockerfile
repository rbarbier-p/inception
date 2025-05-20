FROM alpine:3.20

<<<<<<< HEAD
RUN set -x && apk add --no-cache nginx openssl

COPY ./config/nginx-default.conf /etc/nginx.conf
=======
RUN set -x apk add --no-cache nginx openssl

COPY ./config/nginx-default.config /nginx-default.conf
>>>>>>> 6b89d95e70a5407d2bde014aa2e6a21d9633bd46
COPY ./tools/nginx-entrypoint.sh /nginx-entrypoint.sh

RUN chmod +x /nginx-entrypoint.sh

STOPSIGNAL SIGQUIT

EXPOSE 443

ENTRYPOINT ["/nginx-entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]
