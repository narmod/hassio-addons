ARG BUILD_FROM
FROM $BUILD_FROM

# Pin the embedded web client to an exact release tag
ARG CLIENT_TAG=v2.1.8-web.20

RUN apk add --no-cache nodejs npm git \
 && git clone --depth 1 --branch ${CLIENT_TAG} \
      https://github.com/narmod/pokerth-web-client.git /opt/pokerth-web-client \
 && cd /opt/pokerth-web-client \
 && npm install --omit=dev --no-audit --no-fund \
 && npm cache clean --force \
 && apk del git \
 && rm -rf /opt/pokerth-web-client/.git

WORKDIR /opt/pokerth-web-client
CMD [ "node", "proxy.js" ]
