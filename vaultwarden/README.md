# Vaultwarden

## Github 地址

- 上游项目：https://github.com/dani-garcia/vaultwarden

## 迭代命令

```bash
git switch vaultwarden && \
  git merge main --ff-only && \
  git push origin vaultwarden && \
  git switch main
```

```powershell
git switch vaultwarden ;`
  git merge main --ff-only ;`
  git push origin vaultwarden ;`
  git switch main
```

## 概述

本目录用于构建 Vaultwarden 镜像，基于官方 `vaultwarden/server` 镜像增加 `Asia/Shanghai` 时区配置。

GitHub Actions 工作流位于 `.github/workflows/vaultwarden.yml`，推送 `vaultwarden` 分支时触发构建。当前构建版本为 `1.35.2`，会分别构建 `linux/amd64` 和 `linux/arm64` 镜像，并推送到：

- `registry.cn-qingdao.aliyuncs.com/wod/vaultwarden:1.35.2`
- `ghcr.io/open-beagle/vaultwarden:1.35.2`

工作流同时会为两个架构创建统一的多架构 manifest，运行时可直接使用不带架构后缀的版本标签。
