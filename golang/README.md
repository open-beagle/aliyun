# Golang

## Docker 地址

- 上游镜像：https://hub.docker.com/_/golang

## 迭代命令

### Bash

```bash
# golang-1.18 迭代
git switch golang-1.18 && \
  git merge main --ff-only && \
  git push origin golang-1.18 && \
  git switch main

# golang-1.20 迭代
git switch golang-1.20 && \
  git merge main --ff-only && \
  git push origin golang-1.20 && \
  git switch main

# golang-1.22 迭代
git switch golang-1.22 && \
  git merge main --ff-only && \
  git push origin golang-1.22 && \
  git switch main

# golang-1.24 迭代
git switch golang-1.24 && \
  git merge main --ff-only && \
  git push origin golang-1.24 && \
  git switch main

# golang-1.26 迭代
git switch golang-1.26 && \
  git merge main --ff-only && \
  git push origin golang-1.26 && \
  git switch main
```

### PowerShell

```powershell
# golang-1.18 迭代
git switch golang-1.18 ;`
  git merge main --ff-only ;`
  git push origin golang-1.18 ;`
  git switch main

# golang-1.20 迭代
git switch golang-1.20 ;`
  git merge main --ff-only ;`
  git push origin golang-1.20 ;`
  git switch main

# golang-1.22 迭代
git switch golang-1.22 ;`
  git merge main --ff-only ;`
  git push origin golang-1.22 ;`
  git switch main

# golang-1.24 迭代
git switch golang-1.24 ;`
  git merge main --ff-only ;`
  git push origin golang-1.24 ;`
  git switch main

# golang-1.26 迭代
git switch golang-1.26 ;`
  git merge main --ff-only ;`
  git push origin golang-1.26 ;`
  git switch main
```

## 概述

本目录用于构建 Golang 镜像，基于上游官方镜像进行定制开发，主要集成了：

- **GOPROXY**: 通过 `GOPROXY` build arg 控制；阿里云镜像使用 `https://goproxy.cn`，GHCR 镜像使用 `https://proxy.golang.org,direct`。
- **时区配置**: `Asia/Shanghai` 时区配置。
- **安全与权限**: 添加 `code` 用户 (UID/GID 1000) 并配置无密码 `sudo` 权限，以支持非 root 安全构建。
- **常用工具**: 安装 `git`、`bash`、`curl`、`rsync`、`crossbuild-essential`、`pkg-config`、`clang`、`lld` 等常用构建依赖。

GitHub Actions 工作流文件位于 `.github/workflows/golang-*.yml`，分别推送至对应的迭代分支时会触发构建，并同步推送到阿里云容器镜像服务与 GitHub Container Registry。

GHCR 推送使用 GitHub Actions 自动提供的 `${{ secrets.GITHUB_TOKEN }}`，workflow 需要 `packages: write` 权限。

## 镜像

所有 tag 都同步推送到两个仓库：

- `registry.cn-qingdao.aliyuncs.com/wod/golang`
- `ghcr.io/open-beagle/golang`

两个仓库使用相同 tag 集合，但会按不同 `GOPROXY` 分别构建。

以下仅列 tag，使用时拼接任一仓库前缀。

### Golang 1.26

- **Alpine (v1.26.4)**
  - `1.26.4-alpine`
  - `1.26-alpine`
- **Bookworm (v1.26.4)**
  - `1.26.4-bookworm`
  - `1.26-bookworm`
  - `1.26`

### Golang 1.24

- **Alpine (v1.24.13)**
  - `1.24.13-alpine`
  - `1.24-alpine`
- **Bookworm (v1.24.13)**
  - `1.24.13-bookworm`
  - `1.24-bookworm`
  - `1.24`

### Golang 1.22

- **Alpine (v1.22.12)**
  - `1.22.12-alpine`
  - `1.22-alpine`
- **Bookworm (v1.22.12)**
  - `1.22.12-bookworm`
  - `1.22-bookworm`
  - `1.22`

### Golang 1.20

- **Alpine (v1.20.14)**
  - `1.20.14-alpine`
  - `1.20-alpine`
- **Bullseye (v1.20.14)**
  - `1.20.14-bullseye`
  - `1.20-bullseye`
  - `1.20`

### Golang 1.18

- **Alpine (v1.18.10)**
  - `1.18.10-alpine`
  - `1.18-alpine`
- **Bullseye (v1.18.10)**
  - `1.18.10-bullseye`
  - `1.18-bullseye`
  - `1.18`

## 构建

### Alpine 镜像

```bash
docker build \
  --build-arg BASE=golang:1.26.4-alpine \
  --build-arg GOPROXY=https://goproxy.cn \
  --build-arg AUTHOR=open-beagle \
  --build-arg VERSION=1.26.4 \
  -t registry.cn-qingdao.aliyuncs.com/wod/golang:1.26.4-alpine \
  -f golang/alpine.dockerfile .
```

### Debian Bookworm / Bullseye 镜像 (AMD64)

```bash
docker build \
  --build-arg BASE=golang:1.26.4-bookworm \
  --build-arg GOPROXY=https://goproxy.cn \
  --build-arg AUTHOR=open-beagle \
  --build-arg VERSION=1.26.4 \
  -t registry.cn-qingdao.aliyuncs.com/wod/golang:1.26.4-bookworm-amd64 \
  -f golang/bookworm.dockerfile .
```

### Debian Bookworm / Bullseye 镜像 (ARM64)

```bash
docker build \
  --build-arg BASE=golang:1.26.4-bookworm \
  --build-arg GOPROXY=https://goproxy.cn \
  --build-arg AUTHOR=open-beagle \
  --build-arg VERSION=1.26.4 \
  -t registry.cn-qingdao.aliyuncs.com/wod/golang:1.26.4-bookworm-arm64 \
  -f golang/bookworm-arch.dockerfile .
```

## 推送

```bash
docker push registry.cn-qingdao.aliyuncs.com/wod/golang:1.26.4-alpine
docker push registry.cn-qingdao.aliyuncs.com/wod/golang:1.26.4-bookworm-amd64
docker push registry.cn-qingdao.aliyuncs.com/wod/golang:1.26.4-bookworm-arm64
docker push ghcr.io/open-beagle/golang:1.26.4-alpine
docker push ghcr.io/open-beagle/golang:1.26.4-bookworm-amd64
docker push ghcr.io/open-beagle/golang:1.26.4-bookworm-arm64
```

## 运行

```bash
docker run --rm -it \
  -v $(pwd):/workspace \
  registry.cn-qingdao.aliyuncs.com/wod/golang:1.26.4-alpine \
  bash
```
