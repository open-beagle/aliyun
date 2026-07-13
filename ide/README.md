# IDE

## Github 地址

- 上游项目：https://www.debian.org/
- 上游镜像：https://hub.docker.com/_/debian

## 迭代命令

### Bash

```bash
git switch ide && \
  git merge main --ff-only && \
  git push origin ide && \
  git switch main
```

### PowerShell

```powershell
git switch ide ;`
  git merge main --ff-only ;`
  git push origin ide ;`
  git switch main
```

## 概述

本目录用于构建通用 IDE 开发环境镜像，基于 Debian Trixie。镜像预置 SSH 服务端与客户端、Python 3、Podman 运行时和常用的构建、网络与命令行工具，并创建具有免密 `sudo` 权限的 `code` 用户。

GitHub Actions 工作流位于 `.github/workflows/ide.yml`。推送到 `ide` 分支会构建 `linux/amd64` 和 `linux/arm64` 镜像，并推送到阿里云容器镜像服务。

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
