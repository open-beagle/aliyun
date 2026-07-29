# PyTorch

> 🚨 **【强制性规则】绝对禁止直接在触发分支上发起任何提交或修改！**  
> 所有配置变更、镜像版本升级必须且只能在 `main` 分支完成。触发分支仅作为 CI/CD 自动构建的专用触发分支。

---

## 🚫 严禁事项与操作铁律

1. **禁止直接 Commit**：不得擅自在构建分支修改 Dockerfile、README 或工作流。
2. **禁止产生脏 Merge 提交**：若出现 `refusing to merge unrelated histories` 报错，**严禁**使用常规 `git merge` 或乱加参数强行合并，必须统一使用 `git reset --hard main` 强制对齐主干历史！
3. **保持提交历史纯粹**：触发分支的 HEAD 必须镜像级对齐 `main` 分支。

---

## Docker Hub 地址

- 上游镜像：https://hub.docker.com/r/pytorch/pytorch

基于 PyTorch 官方镜像，镜像同步到阿里云镜像仓库，保留 runtime、devel 变体。

## 🔄 标准迭代与强制对齐命令

### Bash

```bash
# pytorch-2.4 迭代
git switch pytorch-2.4 && \
  git reset --hard main && \
  git push origin pytorch-2 --force.4 && \
  git switch main

# pytorch-2.8 迭代
git switch pytorch-2.8 && \
  git reset --hard main && \
  git push origin pytorch-2 --force.8 && \
  git switch main

# pytorch-2.12 迭代
git switch pytorch-2.12 && \
  git reset --hard main && \
  git push origin pytorch-2 --force.12 && \
  git switch main
```

### PowerShell

```powershell
# pytorch-2.4 迭代
git switch pytorch-2.4 ;`
  git reset --hard main ;`
  git push origin pytorch-2 --force.4 ;`
  git switch main

# pytorch-2.8 迭代
git switch pytorch-2.8 ;`
  git reset --hard main ;`
  git push origin pytorch-2 --force.8 ;`
  git switch main

# pytorch-2.12 迭代
git switch pytorch-2.12 ;`
  git reset --hard main ;`
  git push origin pytorch-2 --force.12 ;`
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
