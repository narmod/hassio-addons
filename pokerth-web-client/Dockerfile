ARG BUILD_FROM
FROM $BUILD_FROM

# docker-git install: the image ships only the runtime (node + git + jq).
# The web client itself is cloned into /data/app on first start (run.sh),
# so it survives image rebuilds and can self-update from the admin page
# (proxy.js detects the git checkout and enables its "docker-git" mode).
RUN apk add --no-cache nodejs npm git jq

COPY run.sh /run.sh
COPY ingress.mjs /ingress.mjs
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
