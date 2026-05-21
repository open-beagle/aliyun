# Xray

## Github 地址

- 上游项目：https://github.com/XTLS/Xray-core

## 迭代命令

```bash
git switch xray && \
  git merge main --ff-only && \
  git push origin xray && \
  git switch main
```

```powershell
git switch xray ;`
  git merge main --ff-only ;`
  git push origin xray ;`
  git switch main
```

## 概述

本目录用于构建 Xray 镜像，基于上游 `ghcr.io/xtls/xray-core` 镜像补充维护者、版本标签和 `Asia/Shanghai` 时区配置。

GitHub Actions 工作流位于 `.github/workflows/xray.yml`，推送 `xray` 分支时触发构建。当前构建版本为 `25.7.26`，会构建 `linux/amd64` 和 `linux/arm64` 镜像，并推送到：

- `registry.cn-qingdao.aliyuncs.com/wod/xray:v25.7.26`

该标签为多平台镜像，可按运行环境自动选择架构。
