# Logto

## Github 地址

- 上游项目：https://github.com/logto-io/logto

## 迭代命令

```bash
git switch logto && \
  git merge main --ff-only && \
  git push origin logto && \
  git switch main
```

```powershell
git switch logto ;`
  git merge main --ff-only ;`
  git push origin logto ;`
  git switch main
```

## 概述

本目录用于构建 Logto 镜像，基于上游 `svhd/logto` 镜像增加 `Asia/Shanghai` 时区配置。

GitHub Actions 工作流位于 `.github/workflows/logto.yml`，推送 `logto` 分支时触发构建。当前构建版本为 `1.35.0`，会分别构建 `linux/amd64` 和 `linux/arm64` 镜像，并推送到：

- `registry.cn-qingdao.aliyuncs.com/wod/logto:1.35.0`
- `ghcr.io/open-beagle/logto:1.35.0`

工作流同时会为两个架构创建统一的多架构 manifest，运行时可直接使用不带架构后缀的版本标签。
