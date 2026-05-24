# Golang

## Github 地址

- 上游项目：https://github.com/golang/go
- 上游镜像：https://hub.docker.com/_/golang

## 迭代命令

### Bash

```bash
# golang-1.17 迭代
git switch golang-1.17 && \
  git merge main --ff-only && \
  git push origin golang-1.17 && \
  git switch main

# golang-1.20 迭代
git switch golang-1.20 && \
  git merge main --ff-only && \
  git push origin golang-1.20 && \
  git switch main

# golang-1.24 迭代
git switch golang-1.24 && \
  git merge main --ff-only && \
  git push origin golang-1.24 && \
  git switch main

# golang-1.25 迭代
git switch golang-1.25 && \
  git merge main --ff-only && \
  git push origin golang-1.25 && \
  git switch main
```

### PowerShell

```powershell
# golang-1.17 迭代
git switch golang-1.17 ;`
  git merge main --ff-only ;`
  git push origin golang-1.17 ;`
  git switch main

# golang-1.20 迭代
git switch golang-1.20 ;`
  git merge main --ff-only ;`
  git push origin golang-1.20 ;`
  git switch main

# golang-1.24 迭代
git switch golang-1.24 ;`
  git merge main --ff-only ;`
  git push origin golang-1.24 ;`
  git switch main

# golang-1.25 迭代
git switch golang-1.25 ;`
  git merge main --ff-only ;`
  git push origin golang-1.25 ;`
  git switch main
```

## 概述

本目录用于构建 Golang 镜像，基于上游官方镜像进行定制开发，主要集成了：
- **GOPROXY**: `https://goproxy.cn` 加速依赖下载。
- **时区配置**: `Asia/Shanghai` 时区配置。
- **安全与权限**: 添加 `code` 用户 (UID/GID 1000) 并配置无密码 `sudo` 权限，以支持非 root 安全构建。
- **常用工具**: 安装 `git`、`bash`、`curl`、`rsync`、`crossbuild-essential`、`pkg-config`、`clang`、`lld` 等常用构建依赖。

GitHub Actions 工作流文件位于 `.github/workflows/golang-*.yml`，分别推送至对应的迭代分支时会触发构建并推送到阿里云容器镜像服务。

## 镜像

### Golang 1.25

- **Alpine (v1.25.10)**
  - `registry.cn-qingdao.aliyuncs.com/wod/golang:1.25.10-alpine`
  - `registry.cn-qingdao.aliyuncs.com/wod/golang:1.25-alpine`
- **Bookworm (v1.25.10)**
  - `registry.cn-qingdao.aliyuncs.com/wod/golang:1.25.10-bookworm`
  - `registry.cn-qingdao.aliyuncs.com/wod/golang:1.25-bookworm`
  - `registry.cn-qingdao.aliyuncs.com/wod/golang:1.25`

### Golang 1.24

- **Alpine (v1.24.13)**
  - `registry.cn-qingdao.aliyuncs.com/wod/golang:1.24.13-alpine`
  - `registry.cn-qingdao.aliyuncs.com/wod/golang:1.24-alpine`
- **Bookworm (v1.24.13)**
  - `registry.cn-qingdao.aliyuncs.com/wod/golang:1.24.13-bookworm`
  - `registry.cn-qingdao.aliyuncs.com/wod/golang:1.24-bookworm`
  - `registry.cn-qingdao.aliyuncs.com/wod/golang:1.24`

### Golang 1.20

- **Alpine (v1.20.14)**
  - `registry.cn-qingdao.aliyuncs.com/wod/golang:1.20.14-alpine`
  - `registry.cn-qingdao.aliyuncs.com/wod/golang:1.20-alpine`
- **Bullseye (v1.20.14)**
  - `registry.cn-qingdao.aliyuncs.com/wod/golang:1.20.14-bullseye`
  - `registry.cn-qingdao.aliyuncs.com/wod/golang:1.20-bullseye`
  - `registry.cn-qingdao.aliyuncs.com/wod/golang:1.20`

### Golang 1.17

- **Alpine (v1.17.13)**
  - `registry.cn-qingdao.aliyuncs.com/wod/golang:1.17.13-alpine`
  - `registry.cn-qingdao.aliyuncs.com/wod/golang:1.17-alpine`
- **Bullseye (v1.17.13)**
  - `registry.cn-qingdao.aliyuncs.com/wod/golang:1.17.13-bullseye`
  - `registry.cn-qingdao.aliyuncs.com/wod/golang:1.17-bullseye`
  - `registry.cn-qingdao.aliyuncs.com/wod/golang:1.17`

## 构建

### Alpine 镜像

```bash
docker build \
  --build-arg BASE=golang:1.25.10-alpine \
  --build-arg AUTHOR=open-beagle \
  --build-arg VERSION=1.25.10 \
  -t registry.cn-qingdao.aliyuncs.com/wod/golang:1.25.10-alpine \
  -f golang/alpine.dockerfile .
```

### Debian Bookworm / Bullseye 镜像 (AMD64)

```bash
docker build \
  --build-arg BASE=golang:1.25.10-bookworm \
  --build-arg AUTHOR=open-beagle \
  --build-arg VERSION=1.25.10 \
  -t registry.cn-qingdao.aliyuncs.com/wod/golang:1.25.10-bookworm-amd64 \
  -f golang/bookworm.dockerfile .
```

### Debian Bookworm / Bullseye 镜像 (ARM64)

```bash
docker build \
  --build-arg BASE=golang:1.25.10-bookworm \
  --build-arg AUTHOR=open-beagle \
  --build-arg VERSION=1.25.10 \
  -t registry.cn-qingdao.aliyuncs.com/wod/golang:1.25.10-bookworm-arm64 \
  -f golang/bookworm-arch.dockerfile .
```

## 推送

```bash
docker push registry.cn-qingdao.aliyuncs.com/wod/golang:1.25.10-alpine
docker push registry.cn-qingdao.aliyuncs.com/wod/golang:1.25.10-bookworm-amd64
docker push registry.cn-qingdao.aliyuncs.com/wod/golang:1.25.10-bookworm-arm64
```

## 运行

```bash
docker run --rm -it \
  -v $(pwd):/workspace \
  registry.cn-qingdao.aliyuncs.com/wod/golang:1.25.10-alpine \
  bash
```
