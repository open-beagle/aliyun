# Mihomo

## Github 地址

- 上游项目：https://github.com/MetaCubeX/mihomo

## 迭代命令

```bash
git switch mihomo && \
  git merge main --ff-only && \
  git push origin mihomo && \
  git switch main
```

```powershell
git switch mihomo ;`
  git merge main --ff-only ;`
  git push origin mihomo ;`
  git switch main
```

## 概述

本目录用于构建 Mihomo 镜像，基于上游 `metacubex/mihomo` 镜像增加 `Asia/Shanghai` 时区配置。

GitHub Actions 工作流位于 `.github/workflows/mihomo.yml`，推送 `mihomo` 分支时触发构建。当前构建版本为 `v1.19.26`，会构建 `linux/amd64` 和 `linux/arm64` 镜像，并推送到：

- `registry.cn-qingdao.aliyuncs.com/wod/mihomo:v1.19.26`

该标签为多平台镜像，可按运行环境自动选择架构。
