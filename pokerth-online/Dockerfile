ARG BUILD_FROM
FROM $BUILD_FROM

# Static-only add-on: a single page embedding the official hosted client.
# busybox httpd ships with the Home Assistant base image — no extra runtime.
COPY www /www

CMD [ "httpd", "-f", "-p", "8100", "-h", "/www" ]
