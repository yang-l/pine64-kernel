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
git clone --progress --depth 1 --single-branch -b pine64-hacks-1.2 https://github.com/longsleep/linux-pine64 || exit 1

[ -d kernel-output ] && rm -fr kernel-output
mkdir -p kernel-output/boot/pine64

cd linux-pine64
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- clean mrproper || exit 1

# curl necessary files
curl -sSL https://github.com/longsleep/build-pine64-image/raw/master/blobs/pine64.dts -o arch/arm64/boot/dts/sun50i-a64-pine64-plus.dts
curl -sSL https://github.com/yang-l/pine64-kernel/raw/config/config-3.10 -o .config

make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- oldconfig || exit 1
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- -j4 LOCALVERSION= Image sun50i-a64-pine64-plus.dtb modules || exit 1

cp arch/arm64/boot/dts/sun50i-a64-pine64-plus.dtb arch/arm64/boot/Image ./.config ../kernel-output/boot/pine64 || exit 1
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- INSTALL_MOD_STRIP=1 modules_install INSTALL_MOD_PATH=../kernel-output || exit 1
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- firmware_install INSTALL_FW_PATH=../kernel-output/lib/firmware || exit 1
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- headers_install INSTALL_HDR_PATH=../kernel-output/usr || exit 1
curl -sSL https://github.com/yang-l/pine64-kernel/raw/initrd/initrd.gz -o ../kernel-output/boot/initrd.img || exit 1

cd ../kernel-output
tar cJpf kernel.tar.xz ./boot ./lib ./usr

EOF
