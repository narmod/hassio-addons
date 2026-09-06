# PokerTH dedicated server — built from the official sources (branch stable).
# Ubuntu questing mirrors the upstream build environment (docker/linux/Dockerfile
# in pokerth/pokerth). Only the pokerth_dedicated_server target is built; build
# tooling is purged afterwards, keeping just the runtime libraries.
FROM ubuntu:questing

ENV DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC

# Pin the exact upstream commit (branch stable, version 2.1.8, 2026-09-04)
ARG POKERTH_COMMIT=d224ff0809dfb237b21787ea87a32ec2dcd05fdb

RUN apt-get update && apt-get upgrade -y \
 && apt-get install -y --no-install-recommends \
      wget git ca-certificates jq build-essential cmake ninja-build \
      libwebsocketpp-dev libprotobuf-dev protobuf-compiler libboost1.88-all-dev \
      qt6-base-dev qt6-svg-dev qt6-declarative-dev qt6-tools-dev linguist-qt6 \
      qt6-websockets-dev qt6-multimedia-dev libqt6sql6-mysql libqt6sql6-sqlite \
      libssl-dev \
 && git clone https://github.com/pokerth/pokerth.git /opt/src \
 && cd /opt/src && git checkout ${POKERTH_COMMIT} \
 && cmake -DCMAKE_BUILD_TYPE:STRING=Release -S. -B./build -G Ninja \
 && cmake --build ./build --config Release --target pokerth_dedicated_server -- \
 && install -m 0755 ./build/src/pokerth_dedicated_server /usr/local/bin/pokerth_dedicated_server \
 # keep every shared library the binary actually needs, purge the rest
 && ldd /usr/local/bin/pokerth_dedicated_server | awk '$3 ~ /^\// {print $3}' \
      | xargs -r dpkg -S 2>/dev/null | cut -d: -f1 | sort -u \
      | xargs -r apt-mark manual \
 # runtime-loaded plugins are invisible to ldd — keep them explicitly
 && apt-mark manual libqt6sql6-sqlite libqt6sql6-mysql ca-certificates \
 && apt-get purge -y build-essential cmake ninja-build git wget \
      'qt6-*-dev' 'lib*-dev' linguist-qt6 protobuf-compiler \
 && apt-get autoremove -y --purge \
 && apt-get clean && rm -rf /opt/src /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY run.sh /run.sh
RUN chmod a+x /run.sh

ENV HOME=/data
CMD [ "/run.sh" ]
