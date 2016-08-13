FROM aarch64/ubuntu

RUN set -xe \
    && apt-get update && apt-get install -y \
       make \
       gcc-5 \
       g++-5 \
       build-essential \
       kmod \
       bc \
       libncurses5-dev \
       bzip2 \
       git \
       curl \
       cpio \
       xz-utils \
    && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 50 \
    && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-5 50 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN locale-gen en_US.UTF-8 \
    && /usr/sbin/update-locale LANG=en_US.UTF-8

ENV LC_ALL en_US.UTF-8
