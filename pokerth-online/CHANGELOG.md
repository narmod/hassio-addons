# Changelog

## 1.0.2

- Fix start: the base image's busybox has no `httpd` applet — serve the page with darkhttpd instead


## 1.0.1

- Fix build: missing `build.yaml` left `$BUILD_FROM` empty
- Drop deprecated armv7


## 1.0.0

- First release: sidebar entry embedding the official hosted web client (webclient.pokerth.net); works locally and through remote access
