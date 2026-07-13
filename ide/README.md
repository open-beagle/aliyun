# IDE

## Github 地址

- 上游项目：https://www.debian.org/
- 上游镜像：https://hub.docker.com/_/debian

## 迭代命令

### Bash

```bash
# 通用 IDE 镜像
git switch ide && \
  git reset --hard main && \
  git push --force-with-lease origin ide && \
  git switch main

# CUDA IDE 镜像
git switch ide-cuda && \
  git reset --hard main && \
  git push --force-with-lease origin ide-cuda && \
  git switch main
```

### PowerShell

```powershell
# 通用 IDE 镜像
git switch ide ;`
  git reset --hard main ;`
  git push --force-with-lease origin ide ;`
  git switch main

# CUDA IDE 镜像
git switch ide-cuda ;`
  git reset --hard main ;`
  git push --force-with-lease origin ide-cuda ;`
  git switch main
```

## 概述

本目录用于构建通用 IDE 开发环境镜像，基于 Debian Trixie。镜像预置以下开发环境：

- **Codex CLI 依赖**：`bubblewrap` 和 `ripgrep`。
- **开发工具链**：Python 3、`pip`、`venv`、`build-essential`、`pkg-config`、Git 与常用命令行工具；PyPI 默认使用阿里云镜像。
- **服务与容器工具**：SSH 服务端与客户端、Podman、crun、fuse-overlayfs、PostgreSQL 客户端与 Redis 工具。
- **网络诊断工具**：`dnsutils`、`net-tools`、`telnet`、`inotify-tools`、`iptables` 与 `iproute2`。

镜像会以 UID/GID 1000 创建或复用 `code` 用户，并配置免密 `sudo` 与 rootless Podman 存储目录。

GitHub Actions 工作流位于 `.github/workflows/ide.yml` 和 `.github/workflows/ide-cuda.yml`。推送到 `ide` 分支会构建 `linux/amd64` 和 `linux/arm64` 通用 IDE 镜像；推送到 `ide-cuda` 分支会构建 AMD64 CUDA IDE 镜像。两者均推送到阿里云容器镜像服务。

## 镜像

### IDE 13 (Debian Trixie)

- **多架构 (AMD64/ARM64)**
  - `registry.cn-qingdao.aliyuncs.com/wod/ide:13`
  - `registry.cn-qingdao.aliyuncs.com/wod/ide:trixie`
- **AMD64**
  - `registry.cn-qingdao.aliyuncs.com/wod/ide:13-amd64`
  - `registry.cn-qingdao.aliyuncs.com/wod/ide:trixie-amd64`
- **ARM64**
  - `registry.cn-qingdao.aliyuncs.com/wod/ide:13-arm64`
  - `registry.cn-qingdao.aliyuncs.com/wod/ide:trixie-arm64`

## 构建

```bash
docker build \
  --build-arg BASE=debian:trixie \
  --build-arg AUTHOR=open-beagle \
  --build-arg VERSION=13 \
  -t registry.cn-qingdao.aliyuncs.com/wod/ide:13 \
  -f ide/debian.dockerfile .
```

## 推送

```bash
docker push registry.cn-qingdao.aliyuncs.com/wod/ide:13
docker push registry.cn-qingdao.aliyuncs.com/wod/ide:13-amd64
docker push registry.cn-qingdao.aliyuncs.com/wod/ide:13-arm64
```

## 运行

```bash
docker run --rm -it \
  -v $(pwd):/workspace \
  registry.cn-qingdao.aliyuncs.com/wod/ide:13 \
  bash
```
