# PokerTH dedicated server — built from the official sources (branch stable).
#
# Multi-stage build:
#  - "build" mirrors the upstream build environment (docker/linux/Dockerfile
#    in pokerth/pokerth) and compiles only the pokerth_dedicated_server target;
#  - the final image installs the exact runtime libraries by name and copies
#    the single binary, with a smoke test that fails the build if anything
#    is missing. No purge/autoremove gymnastics.

FROM ubuntu:questing AS build

ENV DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC

# Pin the exact upstream commit (branch stable, version 2.1.8, 2026-09-04)
ARG POKERTH_COMMIT=d224ff0809dfb237b21787ea87a32ec2dcd05fdb

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      git ca-certificates build-essential cmake ninja-build \
      libwebsocketpp-dev libprotobuf-dev protobuf-compiler libboost1.88-all-dev \
      qt6-base-dev qt6-svg-dev qt6-declarative-dev qt6-tools-dev linguist-qt6 \
      qt6-websockets-dev qt6-multimedia-dev libssl-dev

RUN git clone https://github.com/pokerth/pokerth.git /opt/src \
 && cd /opt/src && git checkout ${POKERTH_COMMIT}

RUN cd /opt/src \
 && cmake -DCMAKE_BUILD_TYPE:STRING=Release -S. -B./build -G Ninja \
 && cmake --build ./build --config Release --target pokerth_dedicated_server --

# ── Runtime image ────────────────────────────────────────────────────────
FROM ubuntu:questing

ENV DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      jq ca-certificates \
      libqt6core6t64 libqt6network6 libqt6xml6 \
      libqt6sql6 libqt6sql6-sqlite libqt6sql6-mysql \
      libboost-system1.88.0 libboost-thread1.88.0 libboost-filesystem1.88.0 \
      libboost-program-options1.88.0 libboost-iostreams1.88.0 \
      libboost-random1.88.0 libboost-regex1.88.0 libboost-chrono1.88.0 \
      libboost-atomic1.88.0 \
      libprotobuf32t64 libssl3t64 \
 && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY --from=build /opt/src/build/bin/pokerth_dedicated_server /usr/local/bin/pokerth_dedicated_server

# Smoke test at build time: the loader resolving every shared library and the
# binary printing its banner proves the runtime set above is complete.
RUN ldd /usr/local/bin/pokerth_dedicated_server | (! grep "not found") \
 && /usr/local/bin/pokerth_dedicated_server --version | grep -q "PokerTH server"

COPY run.sh /run.sh
RUN chmod a+x /run.sh

ENV HOME=/data
CMD [ "/run.sh" ]
