# FaceFusion

## Github 地址

- FaceFusion 主仓库：https://github.com/facefusion/facefusion
- 官方 Docker 仓库：https://github.com/facefusion/facefusion-docker
- Docker 使用文档：https://docs.facefusion.io/usage/run-with-docker
- Docker Hub 镜像：https://hub.docker.com/r/facefusion/facefusion/tags

## 迭代命令

```bash
git switch facefusion && \
  git merge main --ff-only && \
  git push origin facefusion && \
  git switch main
```

```powershell
git switch facefusion ;`
  git merge main --ff-only ;`
  git push origin facefusion ;`
  git switch main
```

## 概述

自定义构建 FaceFusion CUDA 镜像，默认用于 RTX 4090 / Kubernetes GPU 节点运行 WebUI 或 headless 批处理。

本 Dockerfile 基于官方 `facefusion-docker/Dockerfile.cuda`，做了以下处理：

- FaceFusion 固定为 `3.7.1`
- CUDA 基础镜像固定为 `docker.io/nvidia/cuda:12.9.1-cudnn-runtime-ubuntu24.04`
- 安装 `onnxruntime-gpu` CUDA 版本依赖
- 默认监听 `0.0.0.0:7860`
- 默认入口为 `python facefusion.py`，默认命令为 `run --execution-providers cuda`
- 持久化目录为 `/facefusion/.assets`、`/facefusion/.caches`、`/facefusion/.jobs`

GitHub Actions 工作流位于 `.github/workflows/facefusion.yml`，推送 `facefusion` 分支或手动触发工作流时执行构建。推送到：

- `registry.cn-qingdao.aliyuncs.com/wod/verdantflare-app:facefusion-3.7.1-cuda`

## 构建示例

```bash
docker build \
  --build-arg FACEFUSION_VERSION=3.7.1 \
  --build-arg BASE=docker.io/nvidia/cuda:12.9.1-cudnn-runtime-ubuntu24.04 \
  -t registry.cn-qingdao.aliyuncs.com/wod/verdantflare-app:facefusion-3.7.1-cuda \
  ./facefusion
```

如果需要固定你原先验证过的版本，可以改为：

```bash
docker build \
  --build-arg FACEFUSION_VERSION=3.6.1 \
  -t registry.cn-qingdao.aliyuncs.com/wod/verdantflare-app:facefusion-3.6.1-cuda \
  ./facefusion
```

## 运行 WebUI

```bash
docker run --gpus all --rm -it \
  -p 7870:7860 \
  -v $(pwd)/assets:/facefusion/.assets \
  -v $(pwd)/caches:/facefusion/.caches \
  -v $(pwd)/jobs:/facefusion/.jobs \
  registry.cn-qingdao.aliyuncs.com/wod/verdantflare-app:facefusion-3.7.1-cuda
```

访问 `http://localhost:7870`。

## Headless 批处理

```bash
docker run --gpus all --rm -it \
  -v $(pwd)/data:/data \
  -v $(pwd)/assets:/facefusion/.assets \
  -v $(pwd)/caches:/facefusion/.caches \
  -v $(pwd)/jobs:/facefusion/.jobs \
  registry.cn-qingdao.aliyuncs.com/wod/verdantflare-app:facefusion-3.7.1-cuda \
  headless-run \
  --source-paths /data/input/head.jpg \
  --target-path /data/input/source.mp4 \
  --output-path /data/output/final.mp4 \
  --processors face_swapper face_enhancer \
  --execution-providers cuda
```

## Kubernetes

示例文件：

- `k8s-ui.yaml`：Deployment + Service，用于先启动 WebUI 验证
- `k8s-headless-job.yaml`：Job，用于后续批处理

前提条件：

- GPU 节点已安装 NVIDIA 驱动
- 已安装 NVIDIA Container Toolkit 或 NVIDIA GPU Operator
- `kubectl describe node` 能看到 `nvidia.com/gpu`
- Pod 能正常申请 `nvidia.com/gpu: 1`
- 示例 PVC 使用默认 StorageClass，实际部署前按集群存储类和容量调整

```bash
kubectl apply -f facefusion/k8s-ui.yaml
kubectl port-forward svc/facefusion 7870:7870
```

批处理示例：

```bash
kubectl apply -f facefusion/k8s-headless-job.yaml
```
