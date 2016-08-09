#!/usr/bin/env bash

DOCKER_IMAGE=$1
[ -z "${DOCKER_IMAGE}" ] && exit 1

KERNEL_PATH="/srv/kernel"
docker run -i --rm -u root --privileged \
       -v "${KERNEL_PATH}":/srv/kernel \
       "${DOCKER_IMAGE}" /bin/bash -s <<EOF

set -x

cd /srv/kernel
[ -d linux-pine64 ] && rm -fr linux-pine64
[ -d kernel-output ] && rm -fr kernel-output
mkdir -p kernel-output/boot/pine64

git clone --progress --depth 1 --single-branch -b pine64-hacks-1.2 https://github.com/longsleep/linux-pine64
curl -sSL https://github.com/longsleep/build-pine64-image/raw/master/blobs/pine64.dts > linux-pine64/arch/arm64/boot/dts/sun50i-a64-pine64-plus.dts
curl -sSL https://github.com/yang-l/pine64-kernel/raw/config/config-3.10 -o linux-pine64/.config

cd linux-pine64
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- LOCALVERSION= clean
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- LOCALVERSION= oldconfig
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- -j4 LOCALVERSION= Image sun50i-a64-pine64-plus.dtb modules

cp arch/arm64/boot/dts/sun50i-a64-pine64-plus.dtb arch/arm64/boot/Image ./.config ../kernel-output/boot/pine64
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- modules_install INSTALL_MOD_PATH=../kernel-output
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- firmware_install INSTALL_FW_PATH=../kernel-output/lib/firmware
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- headers_install INSTALL_HDR_PATH=../kernel-output/usr
curl -sSL https://github.com/yang-l/pine64-kernel/raw/initrd/initrd.gz -o ../kernel-output/boot/initrd.img

cd ../kernel-output
tar cJpf kernel.tar.xz ./boot ./lib ./usr

EOF
