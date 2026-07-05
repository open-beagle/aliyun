# PyTorch

## Docker Hub 地址

- 上游镜像：https://hub.docker.com/r/pytorch/pytorch

基于 PyTorch 官方镜像，镜像同步到阿里云镜像仓库，保留 runtime、devel 变体。

## 迭代命令

### Bash

```bash
# pytorch-2.4 迭代
git switch pytorch-2.4 && \
  git merge main --ff-only && \
  git push origin pytorch-2.4 && \
  git switch main

# pytorch-2.8 迭代
git switch pytorch-2.8 && \
  git merge main --ff-only && \
  git push origin pytorch-2.8 && \
  git switch main

# pytorch-2.12 迭代
git switch pytorch-2.12 && \
  git merge main --ff-only && \
  git push origin pytorch-2.12 && \
  git switch main
```

### PowerShell

```powershell
# pytorch-2.4 迭代
git switch pytorch-2.4 ;`
  git merge main --ff-only ;`
  git push origin pytorch-2.4 ;`
  git switch main

# pytorch-2.8 迭代
git switch pytorch-2.8 ;`
  git merge main --ff-only ;`
  git push origin pytorch-2.8 ;`
  git switch main

# pytorch-2.12 迭代
git switch pytorch-2.12 ;`
  git merge main --ff-only ;`
  git push origin pytorch-2.12 ;`
  git switch main
```

## 镜像

PyTorch 2.4.1：

- `registry.cn-qingdao.aliyuncs.com/wod/pytorch:2.4.1-cuda12.4-cudnn9-runtime`
- `registry.cn-qingdao.aliyuncs.com/wod/pytorch:2.4.1-cuda12.4-cudnn9-devel`

PyTorch 2.8.0：

- `registry.cn-qingdao.aliyuncs.com/wod/pytorch:2.8.0-cuda12.6-cudnn9-runtime`
- `registry.cn-qingdao.aliyuncs.com/wod/pytorch:2.8.0-cuda12.6-cudnn9-devel`

PyTorch 2.12.1：

- `registry.cn-qingdao.aliyuncs.com/wod/pytorch:2.12.1-cuda13.2-cudnn9-runtime`
- `registry.cn-qingdao.aliyuncs.com/wod/pytorch:2.12.1-cuda13.2-cudnn9-devel`

## 运行

```bash
docker run --rm -it \
  --gpus all \
  registry.cn-qingdao.aliyuncs.com/wod/pytorch:2.12.1-cuda13.2-cudnn9-devel \
  python -c "import torch; print(torch.__version__); print(torch.cuda.is_available())"
```
