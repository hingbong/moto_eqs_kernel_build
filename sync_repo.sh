#!/bin/bash



repo init --depth=1 -u https://git.codelinaro.org/clo/la/kernelplatform/manifest.git -b release -m default_KERNEL.PLATFORM.1.0.r1-16000-kernel.0.xml

repo sync  -f --force-sync --no-clone-bundle --no-tags -j$(nproc --all)

cd kernel_platform

git clone --depth 1 --branch android-13-release-t1sq33.15-11-137-10 https://github.com/MotorolaMobilityLLC/kernel-msm.git

curl -OL "https://raw.githubusercontent.com/tiann/KernelSU/main/kernel/setup.sh"
sed -i "s/common/kernel-msm/g" setup.sh
chmod +x setup.sh
./setup.sh main

