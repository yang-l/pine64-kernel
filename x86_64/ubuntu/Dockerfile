FROM ubuntu:xenial

RUN set -xe \
    && apt-get update && apt-get install -y \
       make \
       gcc-5 \
       gcc-5-aarch64-linux-gnu \
       g++-5-aarch64-linux-gnu \
       bc \
       libncurses5-dev \
       bzip2 \
       git \
       curl \
       cpio \
       xz-utils \
    && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 50 \
    && update-alternatives --install /usr/bin/aarch64-linux-gnu-gcc aarch64-linux-gnu-gcc /usr/bin/aarch64-linux-gnu-gcc-5 50 \
    && update-alternatives --install /usr/bin/aarch64-linux-gnu-g++ aarch64-linux-gnu-g++ /usr/bin/aarch64-linux-gnu-g++-5 50 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
