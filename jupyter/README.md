# jupyter

> 🚨 **【强制性规则】绝对禁止直接在触发分支上发起任何提交或修改！**  
> 所有配置变更、镜像版本升级必须且只能在 `main` 分支完成。触发分支仅作为 CI/CD 自动构建的专用触发分支。

---

## 🚫 严禁事项与操作铁律

1. **禁止直接 Commit**：不得擅自在构建分支修改 Dockerfile、README 或工作流。
2. **禁止产生脏 Merge 提交**：若出现 `refusing to merge unrelated histories` 报错，**严禁**使用常规 `git merge` 或乱加参数强行合并，必须统一使用 `git reset --hard main` 强制对齐主干历史！
3. **保持提交历史纯粹**：触发分支的 HEAD 必须镜像级对齐 `main` 分支。

---

基于 NVIDIA CUDA runtime Ubuntu 24.04 镜像构建 JupyterLab 镜像，默认安装 Python venv、JupyterLab 和中文语言包。

## 🔄 标准迭代与强制对齐命令

```bash
git switch jupyter-12.6 && \
  git reset --hard main && \
  git push origin jupyter-12 --force.6 && \
  git switch main
```

```bash
git switch jupyter-12.8 && \
  git reset --hard main && \
  git push origin jupyter-12 --force.8 && \
  git switch main
```

```bash
git switch jupyter-13.0 && \
  git reset --hard main && \
  git push origin jupyter-13 --force.0 && \
  git switch main
```

```powershell
git switch jupyter-12.6 ;`
  git reset --hard main ;`
  git push origin jupyter-12 --force.6 ;`
  git switch main
```

```powershell
git switch jupyter-12.8 ;`
  git reset --hard main ;`
  git push origin jupyter-12 --force.8 ;`
  git switch main
```

```powershell
git switch jupyter-13.0 ;`
  git reset --hard main ;`
  git push origin jupyter-13 --force.0 ;`
  git switch main
```

## 镜像

- `registry.cn-qingdao.aliyuncs.com/wod/jupyter:12.6.3-runtime-ubuntu24.04`
- `registry.cn-qingdao.aliyuncs.com/wod/cuda:12.6-py312`
- `registry.cn-qingdao.aliyuncs.com/wod/jupyter:12.8.2-runtime-ubuntu24.04`
- `registry.cn-qingdao.aliyuncs.com/wod/cuda:12.8-py312`
- `registry.cn-qingdao.aliyuncs.com/wod/jupyter:13.0.3-runtime-ubuntu24.04`
- `registry.cn-qingdao.aliyuncs.com/wod/cuda:13.0-py312`

## 构建

```bash
docker build \
  --build-arg BASE=nvidia/cuda:12.6.3-runtime-ubuntu24.04 \
  --build-arg AUTHOR=open-beagle \
  --build-arg VERSION=12.6.3-runtime-ubuntu24.04 \
  -t registry.cn-qingdao.aliyuncs.com/wod/jupyter:12.6.3-runtime-ubuntu24.04 \
  -t registry.cn-qingdao.aliyuncs.com/wod/cuda:12.6-py312 \
  -f jupyter/dockerfile .
```

当前 CUDA runtime Ubuntu 24.04 使用 NVIDIA supported tags 中对应小版本的最新 patch：`12.6.3`、`12.8.2`、`13.0.3`。

## 推送

```bash
docker push registry.cn-qingdao.aliyuncs.com/wod/jupyter:12.6.3-runtime-ubuntu24.04
docker push registry.cn-qingdao.aliyuncs.com/wod/cuda:12.6-py312
```

## 运行

```bash
docker run --rm -it \
  --gpus all \
  -p 8888:8888 \
  -p 2222:22 \
  -e ROOT_PASSWORD=password \
  registry.cn-qingdao.aliyuncs.com/wod/jupyter:12.6.3-runtime-ubuntu24.04
```
