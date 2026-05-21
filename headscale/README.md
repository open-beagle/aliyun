# Headscale

## Github 地址

- 上游项目：https://github.com/juanfont/headscale

## 迭代命令

```bash
git switch headscale && \
  git merge main --ff-only && \
  git push origin headscale && \
  git switch main
```

```powershell
git switch headscale ;`
  git merge main --ff-only ;`
  git push origin headscale ;`
  git switch main
```

## 概述

本目录用于构建 Headscale 镜像，基于上游 `headscale/headscale` 镜像增加 `Asia/Shanghai` 时区配置。

GitHub Actions 工作流位于 `.github/workflows/headscale.yml`，推送 `headscale` 分支时触发构建。当前构建版本为 `v0.27.1`，会构建 `linux/amd64` 和 `linux/arm64` 镜像，并推送到：

- `registry.cn-qingdao.aliyuncs.com/wod/headscale:v0.27.1`
- `ghcr.io/open-beagle/headscale:v0.27.1`

该标签为多平台镜像，可按运行环境自动选择架构。
