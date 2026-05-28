# Redis

## Github 地址

- 上游项目：https://github.com/redis/redis
- Docker Hub 镜像：https://hub.docker.com/_/redis

## 迭代命令

```bash
git switch redis-7 && \
  git merge main --ff-only && \
  git push origin redis-7 && \
  git switch main
```

```powershell
git switch redis-7 ;`
  git merge main --ff-only ;`
  git push origin redis-7 ;`
  git switch main
```

## 概述

本目录用于构建 Redis 镜像，基于官方 `redis:7` (Debian) 和 `redis:7-alpine` (Alpine) 镜像补充维护者、版本标签和 `Asia/Shanghai` 时区配置。

GitHub Actions 工作流位于 `.github/workflows/redis-7.yml`，推送 `redis-7` 分支或手动触发工作流时执行构建。当前构建版本为 `7.4.9`，会针对 Debian 和 Alpine 分别构建 `linux/amd64` 和 `linux/arm64` 镜像，并推送到：

**Alpine 基础镜像：**
- `registry.cn-qingdao.aliyuncs.com/wod/redis:7.4.9-alpine`
- `registry.cn-qingdao.aliyuncs.com/wod/redis:7.4.9-alpine-amd64`
- `registry.cn-qingdao.aliyuncs.com/wod/redis:7.4.9-alpine-arm64`

**Debian 基础镜像：**
- `registry.cn-qingdao.aliyuncs.com/wod/redis:7.4.9`
- `registry.cn-qingdao.aliyuncs.com/wod/redis:7.4.9-amd64`
- `registry.cn-qingdao.aliyuncs.com/wod/redis:7.4.9-arm64`

其中不带架构后缀的版本标签为多平台镜像，可按运行环境自动选择架构。
