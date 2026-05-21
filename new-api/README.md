# New API

## Github 地址

- 上游项目：https://github.com/Calcium-Ion/new-api

## 迭代命令

```bash
git switch newapi && \
  git merge main --ff-only && \
  git push origin newapi && \
  git switch main
```

```powershell
git switch newapi ;`
  git merge main --ff-only ;`
  git push origin newapi ;`
  git switch main
```

## 概述

本目录用于构建 New API 镜像，基于上游 `calciumion/new-api` 镜像补充维护者和版本标签。

GitHub Actions 工作流位于 `.github/workflows/newapi.yml`，推送 `newapi` 分支时触发构建。当前构建版本为 `v0.9.22`，会构建 `linux/amd64` 和 `linux/arm64` 镜像，并推送到：

- `registry.cn-qingdao.aliyuncs.com/wod/new-api:v0.9.22`
- `registry.cn-qingdao.aliyuncs.com/wod/new-api:v0.9.22-amd64`
- `registry.cn-qingdao.aliyuncs.com/wod/new-api:v0.9.22-arm64`

其中不带架构后缀的版本标签为多平台镜像，可按运行环境自动选择架构。
