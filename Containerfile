FROM alpine:3.18

ARG BUILD_DATE

LABEL org.opencontainers.image.created="$BUILD_DATE" \
      org.opencontainers.image.authors="Matthias Preu" \
      org.opencontainers.image.url="https://github.com/mpreu/container-squid" \
      org.opencontainers.image.documentation="https://github.com/mpreu/container-squid" \
      org.opencontainers.image.source="https://github.com/mpreu/container-squid" \
      org.opencontainers.image.version="5.9" \
      org.opencontainers.image.title="Squid Container Image" \
      org.opencontainers.image.description="Container image for the Squid caching proxy"

ENV SQUID_VERSION=5.9-r0 \
    SQUID_CACHE_DIR=/var/spool/squid \
    SQUID_LOG_DIR=/var/log/squid \
    SQUID_USER=squid

RUN sed -i -e 's/https/http/' /etc/apk/repositories && apk add --no-cache squid=${SQUID_VERSION}

COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 3128/tcp
ENTRYPOINT ["/sbin/entrypoint.sh"]