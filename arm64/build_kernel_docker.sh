#!/usr/bin/env bash

DOCKER_IMAGE=$1
[ -z "${DOCKER_IMAGE}" ] && exit 1

KERNEL_PATH="/srv/kernel"
docker run -i --rm -u root \
       -v "${KERNEL_PATH}":/srv/kernel \
       "${DOCKER_IMAGE}" /bin/bash -s <<EOF

set -x

cd /srv/kernel
[ -d linux-pine64 ] && rm -fr linux-pine64
git clone --progress --depth 1 --single-branch -b pine64-hacks-1.2 https://github.com/longsleep/linux-pine64

[ -d kernel-output ] && rm -fr kernel-output
mkdir -p kernel-output/boot/pine64

cd linux-pine64
make clean mrproper

# curl necessary files
curl -sSL https://github.com/longsleep/build-pine64-image/raw/master/blobs/pine64.dts -o arch/arm64/boot/dts/sun50i-a64-pine64-plus.dts
curl -sSL https://github.com/yang-l/pine64-kernel/raw/config/config-3.10 -o .config

make oldconfig
make -j4 LOCALVERSION= Image sun50i-a64-pine64-plus.dtb modules

cp arch/arm64/boot/dts/sun50i-a64-pine64-plus.dtb arch/arm64/boot/Image ./.config ../kernel-output/boot/pine64
make INSTALL_MOD_STRIP=1 modules_install INSTALL_MOD_PATH=../kernel-output
make firmware_install INSTALL_FW_PATH=../kernel-output/lib/firmware
make headers_install INSTALL_HDR_PATH=../kernel-output/usr
curl -sSL https://github.com/yang-l/pine64-kernel/raw/initrd/initrd.gz -o ../kernel-output/boot/initrd.img

cd ../kernel-output
tar cJpf kernel.tar.xz ./boot ./lib ./usr

EOF
