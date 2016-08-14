#!/usr/bin/env bash

DOCKER_IMAGE=$1
[ -z "${DOCKER_IMAGE}" ] && exit 1

KERNEL_PATH="/srv/kernel"
docker run -i --rm -u root \
       -v "${KERNEL_PATH}":/srv/kernel \
       "${DOCKER_IMAGE}" /bin/bash -s <<EOF

set -x

cd /srv/kernel
[ -d linux ] && rm -fr linux
git clone --progress --depth 1 --single-branch -b a64-v5 https://github.com/apritzel/linux

[ -d kernel-output ] && rm -fr kernel-output
dir -p kernel-output/boot/pine64

cd linux
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- clean mrproper

# curl necessary file
#curl -sSL https://github.com/yang-l/pine64-kernel/raw/config/config-3.10 -o .config

make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- oldconfig
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- -j4 LOCALVERSION= Image modules dtbs

cp arch/arm64/boot/dts/allwinner/sun50i-a64-pine64-plus.dtb arch/arm64/boot/Image ./.config ../kernel-output/boot/pine64
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- modules_install INSTALL_MOD_PATH=../kernel-output
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- firmware_install INSTALL_FW_PATH=../kernel-output/lib/firmware
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- headers_install INSTALL_HDR_PATH=../kernel-output/usr
curl -sSL https://github.com/yang-l/pine64-kernel/raw/initrd/initrd.gz -o ../kernel-output/boot/initrd.img

cd ../kernel-output
tar cJpf kernel.tar.xz ./boot ./lib ./usr

EOF
