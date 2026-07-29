# CUDA

> 🚨 **【强制性规则】绝对禁止直接在触发分支上发起任何提交或修改！**  
> 所有配置变更、镜像版本升级必须且只能在 `main` 分支完成。触发分支仅作为 CI/CD 自动构建的专用触发分支。

---

## 🚫 严禁事项与操作铁律

1. **禁止直接 Commit**：不得擅自在构建分支修改 Dockerfile、README 或工作流。
2. **禁止产生脏 Merge 提交**：若出现 `refusing to merge unrelated histories` 报错，**严禁**使用常规 `git merge` 或乱加参数强行合并，必须统一使用 `git reset --hard main` 强制对齐主干历史！
3. **保持提交历史纯粹**：触发分支的 HEAD 必须镜像级对齐 `main` 分支。

---

基于 NVIDIA CUDA 上游镜像构建 CUDA 镜像，保留上游 runtime、devel、cudnn 变体，并推送到阿里云镜像仓库。

## 🔄 标准迭代与强制对齐命令

```bash
git switch cuda-12.6 && \
  git reset --hard main && \
  git push origin cuda-12 --force.6 && \
  git switch main
```

```bash
git switch cuda-12.8 && \
  git reset --hard main && \
  git push origin cuda-12 --force.8 && \
  git switch main
```

```bash
git switch cuda-13.0 && \
  git reset --hard main && \
  git push origin cuda-13 --force.0 && \
  git switch main
```

```bash
git switch cuda-12.9 && \
  git reset --hard main && \
  git push origin cuda-12 --force.9 && \
  git switch main
```

```powershell
git switch cuda-12.6 ;`
  git reset --hard main ;`
  git push origin cuda-12 --force.6 ;`
  git switch main
```

```powershell
git switch cuda-12.8 ;`
  git reset --hard main ;`
  git push origin cuda-12 --force.8 ;`
  git switch main
```

```powershell
git switch cuda-13.0 ;`
  git reset --hard main ;`
  git push origin cuda-13 --force.0 ;`
  git switch main
```

```powershell
git switch cuda-12.9 ;`
  git reset --hard main ;`
  git push origin cuda-12 --force.9 ;`
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
