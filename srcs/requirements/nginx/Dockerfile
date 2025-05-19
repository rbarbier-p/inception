FROM alpine:3.20

RUN apk add --no-cache nginx openssl

COPY nginx-default.config /nginx-default.conf
COPY nginx-entrypoint.sh /nginx-entrypoint.sh

RUN chmod +x /nginx-entrypoint.sh

EXPOSE 80 443

ENTRYPOINT ["/nginx-entrypoint.sh"]
