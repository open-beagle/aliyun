# OpenWRT ImageBuilder

## Github 地址

- 上游项目：https://hub.docker.com/r/openwrt/imagebuilder

## 迭代命令

```bash
git switch openwrt-v24.10 && \
  git merge main --ff-only && \
  git push origin openwrt-v24.10 && \
  git switch main
```

```powershell
git switch openwrt-v24.10 ;`
  git merge main --ff-only ;`
  git push origin openwrt-v24.10 ;`
  git switch main
```

## 概述

本目录用于构建 OpenWRT ImageBuilder 镜像，基于上游 `openwrt/imagebuilder` 镜像。

GitHub Actions 工作流位于 `.github/workflows/openwrt-v24.10.yml`，推送 `openwrt-v24.10` 分支时触发构建。当前构建版本为 `v24.10.7`，会构建 `x86-64` 和 `rockchip-armv8` 镜像，并推送到：

- `registry.cn-qingdao.aliyuncs.com/wod/openwrt-imagebuilder:x86-64-v24.10.7`
- `registry.cn-qingdao.aliyuncs.com/wod/openwrt-imagebuilder:rockchip-armv8-v24.10.7`
