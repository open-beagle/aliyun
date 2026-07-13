# IDE CUDA

## Github 地址

- 上游项目：https://developer.nvidia.com/cuda-toolkit
- 上游镜像：https://hub.docker.com/r/nvidia/cuda

## 迭代命令

### Bash

```bash
git switch ide-cuda && \
  git merge main --ff-only && \
  git push origin ide-cuda && \
  git switch main
```

### PowerShell

```powershell
git switch ide-cuda ;`
  git merge main --ff-only ;`
  git push origin ide-cuda ;`
  git switch main
```

## 概述

本目录用于构建 CUDA IDE 开发环境镜像，基于 `nvidia/cuda:12.6.3-devel-ubuntu24.04`。镜像包含 CUDA 开发环境、Python 3 与 `pip`、SSH 服务端和客户端、Podman 运行时，以及 PostgreSQL、Redis、网络诊断和常用构建工具。

镜像会以 UID/GID 1000 创建或复用 `code` 用户，并配置免密 `sudo` 与 rootless Podman 存储目录。

GitHub Actions 工作流位于 `.github/workflows/ide-cuda.yml`。推送到 `ide-cuda` 分支会构建并推送 AMD64 镜像到阿里云容器镜像服务。

## 镜像

### CUDA 12.6.3 (Ubuntu 24.04)

- **AMD64**
  - `registry.cn-qingdao.aliyuncs.com/wod/ide:cuda12.6.3-devel-ubuntu24.04`

## 构建

```bash
docker build \
  --build-arg BASE=nvidia/cuda:12.6.3-devel-ubuntu24.04 \
  --build-arg AUTHOR=open-beagle \
  --build-arg VERSION=12.6.3-devel-ubuntu24.04 \
  -t registry.cn-qingdao.aliyuncs.com/wod/ide:cuda12.6.3-devel-ubuntu24.04 \
  -f ide-cuda/dockerfile .
```

## 推送

```bash
docker push registry.cn-qingdao.aliyuncs.com/wod/ide:cuda12.6.3-devel-ubuntu24.04
```

## 运行

主机需要安装 NVIDIA Container Toolkit，才能将 GPU 暴露给容器：

```bash
docker run --rm -it --gpus all \
  -v $(pwd):/workspace \
  registry.cn-qingdao.aliyuncs.com/wod/ide:cuda12.6.3-devel-ubuntu24.04 \
  bash
```
