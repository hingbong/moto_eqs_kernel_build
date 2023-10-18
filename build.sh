#!/bin/bash
cd kernel_platform
KERNEL_PLATFORM_PATH=$PWD

env
OLD_PATH=$PATH

export PATH=${KERNEL_PLATFORM_PATH}/prebuilts-master/clang/host/linux-x86/clang-r416183c/bin:${KERNEL_PLATFORM_PATH}/build/build-tools/path/linux-x86:${KERNEL_PLATFORM_PATH}/prebuilts/build-tools/linux-x86/bin:${KERNEL_PLATFORM_PATH}/prebuilts/build-tools/common/bin:${KERNEL_PLATFORM_PATH}/prebuilts/gcc/linux-x86/host/x86_64-linux-glibc2.17-4.8/bin:${KERNEL_PLATFORM_PATH}/prebuilts/kernel-build-tools/linux-x86/bin:$OLD_PATH

cd kernel-msm


export ARCH=arm64
export CROSS_COMPILE=aarch64-linux-gnu-
make mrproper V=2
KCONFIG_CONFIG=arch/arm64/configs/eqs_defconfig \
 ARCH=arm64 scripts/kconfig/merge_config.sh -m -r -y \
  arch/arm64/configs/gki_defconfig arch/arm64/configs/vendor/waipio_GKI.config arch/arm64/configs/vendor/ext_config/moto-waipio.config \
  arch/arm64/configs/vendor/ext_config/moto-waipio-eqs.config arch/arm64/configs/vendor/ext_config/factory-waipio.config \
  arch/arm64/configs/vendor/ext_config/moto-waipio-gki.config ${GITHUB_WORKSPACE}/myconfig

make LLVM=1 CC=clang LLVM_IAS=1 V=2 EPMOD=depmod DTC=dtc eqs_defconfig || exit 1

echo "--------------------------------"
aarch64-linux-gnu-as --version

grep CONFIG_BROKEN_GAS_INST .config

echo "--------------------------------"

make LLVM=1 CC=clang V=2 LLVM_IAS=1 DEPMOD=depmod DTC=dtc Image -j$(nproc --all) || make LLVM=1 V=2 LLVM_IAS=1 DEPMOD=depmod DTC=dtc Image || exit 1

ls -lh arch/arm64/boot/

realpath arch/arm64/boot/Image
