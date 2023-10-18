#!/bin/bash
cd kernel_platform/kernel-msm
git apply -v ${GITHUB_WORKSPACE}/moto_kernel_diff.diff
