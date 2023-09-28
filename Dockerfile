FROM debian:12

ARG OPENTTD_VERSION="13.4"
ARG OPENTTD_CHECKSUM="943b7be04130ea790323f70bf5476ccf17692a6e89790748e90aa590b7db4370"
ARG OPENTTD_URL="https://cdn.openttd.org/openttd-releases/${OPENTTD_VERSION}/openttd-${OPENTTD_VERSION}-linux-generic-amd64.tar.xz"

ARG OPENGFX_VERSION="7.1"
ARG OPENGFX_CHECKSUM="928fcf34efd0719a3560cbab6821d71ce686b6315e8825360fba87a7a94d7846"
ARG OPENGFX_URL="https://cdn.openttd.org/opengfx-releases/${OPENGFX_VERSION}/opengfx-${OPENGFX_VERSION}-all.zip"

RUN DEBIAN_FRONTEND=noninteractive apt-get update            \
    && apt-get install --quiet --yes --no-install-recommends \
        libfluidsynth3                                       \
        libfontconfig1                                       \
        libfreetype6                                         \
        libicu72                                             \
        liblzo2-2                                            \
        libpng16-16                                          \
        libsdl2-2.0-0                                        \
        sudo                                                 \
        tini                                                 \
        unzip                                                \
        xz-utils                                             \
    && apt-get clean      --quiet --yes                      \
    && apt-get autoremove --quiet --yes                      \
    && rm -rf /var/lib/apt/lists/*

# install openttd
ADD ${OPENTTD_URL} /tmp/openttd.tar.xz
RUN echo "${OPENTTD_CHECKSUM} /tmp/openttd.tar.xz" | sha256sum -c -               \
    && mkdir -p /opt/openttd/                                                     \
    && tar xvf /tmp/openttd.tar.xz --directory /opt/openttd/ --strip-components=1 \
    && rm -f /tmp/openttd.tar.xz

# install opengfx
ADD ${OPENGFX_URL} /tmp/opengfx.zip
RUN echo "${OPENGFX_CHECKSUM} /tmp/opengfx.zip" | sha256sum -c - \
    && unzip /tmp/opengfx.zip -d /opt/openttd/baseset/           \
    && rm -f /tmp/opengfx.zip

COPY entrypoint.sh /entrypoint.sh

ENV PUID=1000
ENV PGID=1000

EXPOSE 3979/tcp 3979/udp

ENTRYPOINT ["tini", "-vv", "--", "/entrypoint.sh"]
