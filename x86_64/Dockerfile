FROM ubuntu:xenial

RUN set -xe \
    && apt-get update && apt-get install -y \
       make \
       gcc \
       gcc-aarch64-linux-gnu \
       bc \
       libncurses5-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["/bin/bash"]
