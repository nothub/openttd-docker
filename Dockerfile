FROM debian:11

ARG OPENTTD_VERSION="12.2"
ARG OPENTTD_CHECKSUM="017df609442ddd40fd24da164755b3da3aba16f6de36677e7bffbe041c35715c"
ARG OPENTTD_URL="https://cdn.openttd.org/openttd-releases/${OPENTTD_VERSION}/openttd-${OPENTTD_VERSION}-linux-debian-bullseye-amd64.deb"

ARG OPENGFX_VERSION="7.1"
ARG OPENGFX_CHECKSUM="928fcf34efd0719a3560cbab6821d71ce686b6315e8825360fba87a7a94d7846"
ARG OPENGFX_URL="https://cdn.openttd.org/opengfx-releases/${OPENGFX_VERSION}/opengfx-${OPENGFX_VERSION}-all.zip"

RUN DEBIAN_FRONTEND=noninteractive apt-get update            \
    && apt-get install --quiet --yes --no-install-recommends \
        libfluidsynth2                                       \
        libfontconfig1                                       \
        libfreetype6                                         \
        libicu67                                             \
        liblzo2-2                                            \
        libpng16-16                                          \
        libsdl2-2.0-0                                        \
        sudo                                                 \
        tini                                                 \
        unzip                                                \
    && apt-get clean      --quiet --yes                      \
    && apt-get autoremove --quiet --yes                      \
    && rm -rf /var/lib/apt/lists/*

# install openttd
ADD ${OPENTTD_URL} /tmp/openttd.deb
RUN echo "${OPENTTD_CHECKSUM} /tmp/openttd.deb" | sha256sum -c - \
    && dpkg --install /tmp/openttd.deb                           \
    && rm -f /tmp/openttd.deb

# install opengfx
ADD ${OPENGFX_URL} /tmp/opengfx.zip
RUN echo "${OPENGFX_CHECKSUM} /tmp/opengfx.zip" | sha256sum -c - \
    && unzip /tmp/opengfx.zip -d /tmp/                           \
    && mkdir -p /usr/share/games/openttd/baseset/                \
    && cd /usr/share/games/openttd/baseset/                      \
    && tar xvf /tmp/opengfx-${OPENGFX_VERSION}.tar               \
    && rm -f /tmp/opengfx.*

COPY entrypoint.sh /entrypoint.sh

ENV PUID=1000
ENV PGID=1000

ENV LOAD_AUTOSAVE="false"

EXPOSE 3979/tcp 3979/udp

ENTRYPOINT ["tini", "-vv", "--", "/entrypoint.sh"]
