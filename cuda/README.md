# CUDA

基于 NVIDIA CUDA 上游镜像构建 CUDA 镜像，保留上游 runtime、devel、cudnn 变体，并推送到阿里云镜像仓库。

## 迭代命令

```bash
git switch cuda-12.6 && \
  git merge main --ff-only && \
  git push origin cuda-12.6 && \
  git switch main
```

```bash
git switch cuda-12.8 && \
  git merge main --ff-only && \
  git push origin cuda-12.8 && \
  git switch main
```

```bash
git switch cuda-13.0 && \
  git merge main --ff-only && \
  git push origin cuda-13.0 && \
  git switch main
```

```bash
git switch cuda-12.9 && \
  git merge main --ff-only && \
  git push origin cuda-12.9 && \
  git switch main
```

```powershell
git switch cuda-12.6 ;`
  git merge main --ff-only ;`
  git push origin cuda-12.6 ;`
  git switch main
```

```powershell
git switch cuda-12.8 ;`
  git merge main --ff-only ;`
  git push origin cuda-12.8 ;`
  git switch main
```

```powershell
git switch cuda-13.0 ;`
  git merge main --ff-only ;`
  git push origin cuda-13.0 ;`
  git switch main
```

```powershell
git switch cuda-12.9 ;`
  git merge main --ff-only ;`
  git push origin cuda-12.9 ;`
  git switch main
```

## 镜像

CUDA 12.6.3：

- `registry.cn-qingdao.aliyuncs.com/wod/cuda:12.6.3-runtime-ubuntu22.04`
- `registry.cn-qingdao.aliyuncs.com/wod/cuda:12.6.3-cudnn-runtime-ubuntu22.04`
- `registry.cn-qingdao.aliyuncs.com/wod/cuda:12.6.3-devel-ubuntu24.04`
- `registry.cn-qingdao.aliyuncs.com/wod/cuda:12.6.3-cudnn-devel-ubuntu24.04`

CUDA 12.8.2：

- `registry.cn-qingdao.aliyuncs.com/wod/cuda:12.8.2-runtime-ubuntu22.04`
- `registry.cn-qingdao.aliyuncs.com/wod/cuda:12.8.2-cudnn-runtime-ubuntu22.04`
- `registry.cn-qingdao.aliyuncs.com/wod/cuda:12.8.2-runtime-ubuntu24.04`
- `registry.cn-qingdao.aliyuncs.com/wod/cuda:12.8.2-devel-ubuntu24.04`
- `registry.cn-qingdao.aliyuncs.com/wod/cuda:12.8.2-cudnn-devel-ubuntu24.04`

CUDA 12.9.1：

- `registry.cn-qingdao.aliyuncs.com/wod/cuda:12.9.1-cudnn-runtime-ubuntu24.04`

CUDA 13.0.3：

- `registry.cn-qingdao.aliyuncs.com/wod/cuda:13.0.3-runtime-ubuntu24.04`
- `registry.cn-qingdao.aliyuncs.com/wod/cuda:13.0.3-devel-ubuntu24.04`
- `registry.cn-qingdao.aliyuncs.com/wod/cuda:13.0.3-cudnn-devel-ubuntu24.04`

## 构建

```bash
docker build \
  --build-arg BASE=nvidia/cuda:12.8.2-runtime-ubuntu24.04 \
  --build-arg AUTHOR=open-beagle \
  --build-arg VERSION=12.8.2 \
  -t registry.cn-qingdao.aliyuncs.com/wod/cuda:12.8.2-runtime-ubuntu24.04 \
  -f cuda/dockerfile .
```

## 推送

```bash
docker push registry.cn-qingdao.aliyuncs.com/wod/cuda:12.8.2-runtime-ubuntu24.04
```

## 运行

```bash
docker run --rm -it \
  --gpus all \
  registry.cn-qingdao.aliyuncs.com/wod/cuda:12.8.2-runtime-ubuntu24.04 \
  nvidia-smi
```
