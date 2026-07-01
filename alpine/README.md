# Alpine

## Github 地址

- 上游项目：https://alpinelinux.org/
- 上游镜像：https://hub.docker.com/_/alpine

## 迭代命令

### Bash

```bash
# alpine 迭代
git switch alpine && \
  git merge main --ff-only && \
  git push origin alpine && \
  git switch main
```

### PowerShell

```powershell
# alpine 迭代
git switch alpine ;`
  git merge main --ff-only ;`
  git push origin alpine ;`
  git switch main
```

## 概述

本目录用于构建 Alpine 镜像，基于上游官方镜像进行定制开发，主要集成了：

- **包管理器加速**: 使用 `mirrors.aliyun.com` 替换默认源。
- **时区配置**: 安装 `tzdata` 并配置 `Asia/Shanghai` 时区。
- **常用工具**: 安装 `bash`、`ca-certificates`、`curl`、`iptables`、`iproute2` 等基础工具。
- **证书配置**: 导入 Beagle 内部 CA 证书（`beagle-ca.crt`）以信任内部服务。

GitHub Actions 工作流文件位于 `.github/workflows/alpine.yml`，推送到 `alpine` 分支时会触发构建并推送到阿里云容器镜像服务。支持 `linux/amd64` 和 `linux/arm64` 多架构。

## 镜像

### Alpine 3.22

- **多架构 (AMD64/ARM64)**
  - `registry.cn-qingdao.aliyuncs.com/wod/alpine:3.22.5`
  - `registry.cn-qingdao.aliyuncs.com/wod/alpine:3.22`
  - `registry.cn-qingdao.aliyuncs.com/wod/alpine:3`
- **AMD64**
  - `registry.cn-qingdao.aliyuncs.com/wod/alpine:3.22.5-amd64`
  - `registry.cn-qingdao.aliyuncs.com/wod/alpine:3.22-amd64`
  - `registry.cn-qingdao.aliyuncs.com/wod/alpine:3-amd64`
- **ARM64**
  - `registry.cn-qingdao.aliyuncs.com/wod/alpine:3.22.5-arm64`
  - `registry.cn-qingdao.aliyuncs.com/wod/alpine:3.22-arm64`
  - `registry.cn-qingdao.aliyuncs.com/wod/alpine:3-arm64`

## 构建

### 镜像构建

```bash
docker build \
  --build-arg BASE=alpine:3.22.5 \
  --build-arg AUTHOR=open-beagle \
  --build-arg VERSION=3.22.5 \
  -t registry.cn-qingdao.aliyuncs.com/wod/alpine:3.22.5 \
  -f alpine/alpine.dockerfile .
```

## 推送

```bash
docker push registry.cn-qingdao.aliyuncs.com/wod/alpine:3.22.5
docker push registry.cn-qingdao.aliyuncs.com/wod/alpine:3.22.5-amd64
docker push registry.cn-qingdao.aliyuncs.com/wod/alpine:3.22.5-arm64
```

## 运行

```bash
docker run --rm -it \
  -v $(pwd):/workspace \
  registry.cn-qingdao.aliyuncs.com/wod/alpine:3.22.5 \
  bash
```
