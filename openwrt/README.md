# OpenWRT ImageBuilder

## Github 地址

- 上游项目：https://hub.docker.com/r/openwrt/imagebuilder

## 迭代命令

### 对于 v25 版本 (最新)

```bash
git switch openwrt-v25 && \
  git merge main --ff-only && \
  git push origin openwrt-v25 && \
  git switch main
```

```powershell
git switch openwrt-v25 ;`
  git merge main --ff-only ;`
  git push origin openwrt-v25 ;`
  git switch main
```

### 对于 v24 版本

```bash
git switch openwrt-v24 && \
  git merge main --ff-only && \
  git push origin openwrt-v24 && \
  git switch main
```

```powershell
git switch openwrt-v24 ;`
  git merge main --ff-only ;`
  git push origin openwrt-v24 ;`
  git switch main
```

## 概述

本目录用于构建 OpenWRT ImageBuilder 镜像，基于上游 `openwrt/imagebuilder` 镜像。

GitHub Actions 工作流根据不同的版本有不同的配置文件：

- 对于 `v25`：工作流位于 `.github/workflows/openwrt-v25.yml`，推送 `openwrt-v25` 分支时触发构建。当前构建版本为 `v25.12.4`，会构建 `x86-64` 和 `rockchip-armv8` 镜像，并推送到：
  - `registry.cn-qingdao.aliyuncs.com/wod/openwrt-imagebuilder:x86-64-v25.12.4`
  - `registry.cn-qingdao.aliyuncs.com/wod/openwrt-imagebuilder:rockchip-armv8-v25.12.4`

- 对于 `v24`：工作流位于 `.github/workflows/openwrt-v24.yml`，推送 `openwrt-v24` 分支时触发构建。当前构建版本为 `v24.10.7`，会构建 `x86-64` 和 `rockchip-armv8` 镜像，并推送到：
  - `registry.cn-qingdao.aliyuncs.com/wod/openwrt-imagebuilder:x86-64-v24.10.7`
  - `registry.cn-qingdao.aliyuncs.com/wod/openwrt-imagebuilder:rockchip-armv8-v24.10.7`
