ARG BUILD_FROM
FROM $BUILD_FROM

# Static-only add-on: a single page embedding the official hosted client.
# darkhttpd is a ~100 KB static file server (the base image's busybox has
# no httpd applet).
RUN apk add --no-cache darkhttpd

COPY www /www

CMD [ "darkhttpd", "/www", "--port", "8100" ]
