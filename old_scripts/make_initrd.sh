#!/usr/bin/env bash
set -x

mkdir output
cd output

git clone --depth 1 --branch 1_24_stable --single-branch git://git.busybox.net/busybox busybox
curl -sLk https://github.com/longsleep/build-pine64-image/raw/master/kernel/pine64_config_busybox -o busybox/.config

cd busybox
make -j4 oldconfig
make -j4

cd -
mkdir script
curl -sLk https://github.com/longsleep/build-pine64-image/raw/master/kernel/make_initrd.sh -o script/make_initrd.sh
cd script
bash make_initrd.sh
