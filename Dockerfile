FROM scratch
COPY --from=qemux/qemu-arm:3.01 / /

ARG VERSION_ARG="0.00"
ARG DEBCONF_NOWARNINGS="yes"
ARG DEBIAN_FRONTEND="noninteractive"
ARG DEBCONF_NONINTERACTIVE_SEEN="true"

RUN set -eu && \
    apt-get update && \
    apt-get --no-install-recommends -y install \
        bc \
        jq \
        curl \
        7zip \
        wsdd \
        samba \
        xz-utils \
        wimtools \
        dos2unix \
        cabextract \
        genisoimage \
        libxml2-utils \
        libarchive-tools && \
    apt-get clean && \
    echo "$VERSION_ARG" > /run/version && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY --chmod=755 ./src /run/
COPY --chmod=755 ./assets /run/assets

ADD --chmod=664 https://github.com/qemus/virtiso-arm/releases/download/v0.1.266-1/virtio-win-0.1.266.tar.xz /drivers.txz

VOLUME /storage
EXPOSE 8006 3389

ENV VERSION="tiny10"
ENV RAM_SIZE="0.5G"
ENV CPU_CORES="1"
ENV DISK_SIZE="32G"
ENV KVM="N"

ENTRYPOINT ["/usr/bin/tini", "-s", "/run/entry.sh"]
