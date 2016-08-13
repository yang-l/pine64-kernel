FROM aarch64/debian:jessie

RUN set -xe \
    && apt-get update && apt-get install -y \
       make \
       gcc \
       g++ \
       kmod \
       bc \
       libncurses5-dev \
       bzip2 \
       git \
       curl \
       cpio \
       xz-utils \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
