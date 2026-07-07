# Caddy

## Github 地址

- 上游项目：https://github.com/caddyserver/caddy
- Docker Hub 镜像：https://hub.docker.com/_/caddy

## 迭代命令

```bash
git switch caddy-2 && \
  git merge main --ff-only && \
  git push origin caddy-2 && \
  git switch main
```

```powershell
git switch caddy-2 ;`
  git merge main --ff-only ;`
  git push origin caddy-2 ;`
  git switch main
```

## 概述

本目录用于构建 Caddy 镜像，基于官方 `caddy:2.11.4-alpine` 镜像补充维护者、版本标签、`Asia/Shanghai` 时区配置和内部 CA 证书。

GitHub Actions 工作流位于 `.github/workflows/caddy.yml`，推送 `caddy-2` 分支或手动触发工作流时执行构建。当前构建版本为 `2.11.4`，会构建 `linux/amd64` 和 `linux/arm64` 镜像，并推送到：

- `registry.cn-qingdao.aliyuncs.com/wod/caddy:2.11.4`
- `registry.cn-qingdao.aliyuncs.com/wod/caddy:2.11`
- `registry.cn-qingdao.aliyuncs.com/wod/caddy:2`
- `registry.cn-qingdao.aliyuncs.com/wod/caddy:2.11.4-alpine`
- `registry.cn-qingdao.aliyuncs.com/wod/caddy:2.11-alpine`
- `registry.cn-qingdao.aliyuncs.com/wod/caddy:2-alpine`
- `registry.cn-qingdao.aliyuncs.com/wod/caddy:2.11.4-amd64`
- `registry.cn-qingdao.aliyuncs.com/wod/caddy:2.11.4-arm64`
- `registry.cn-qingdao.aliyuncs.com/wod/caddy:2.11.4-alpine-amd64`
- `registry.cn-qingdao.aliyuncs.com/wod/caddy:2.11.4-alpine-arm64`

其中不带架构后缀的版本标签为多平台镜像，可按运行环境自动选择架构。

## 使用示例

```bash
docker run --rm \
  registry.cn-qingdao.aliyuncs.com/wod/caddy:2 \
  caddy version
```
