# Python

> 🚨 **【强制性规则】绝对禁止直接在触发分支上发起任何提交或修改！**  
> 所有配置变更、镜像版本升级必须且只能在 `main` 分支完成。触发分支仅作为 CI/CD 自动构建的专用触发分支。

---

## 🚫 严禁事项与操作铁律

1. **禁止直接 Commit**：不得擅自在构建分支修改 Dockerfile、README 或工作流。
2. **禁止产生脏 Merge 提交**：若出现 `refusing to merge unrelated histories` 报错，**严禁**使用常规 `git merge` 或乱加参数强行合并，必须统一使用 `git reset --hard main` 强制对齐主干历史！
3. **保持提交历史纯粹**：触发分支的 HEAD 必须镜像级对齐 `main` 分支。

---

## Docker Hub 地址

- 上游镜像：https://hub.docker.com/_/python

本目录用于构建 Python 镜像，基于上游项目进行定制开发，主要集成了 Beagle 内部环境的配置（如加速源、CA 证书、时区等），并预装了 poetry。

推送到 `python-3.x` 系列分支（例如 `python-3.12`）时，会触发相应的 GitHub Actions 工作流构建镜像并推送到阿里云容器镜像服务。

## 🔄 标准迭代与强制对齐命令

### Bash

```bash
# python-3.10 迭代
git switch python-3.10 && \
  git reset --hard main && \
  git push origin python-3 --force.10 && \
  git switch main

# python-3.11 迭代
git switch python-3.11 && \
  git reset --hard main && \
  git push origin python-3 --force.11 && \
  git switch main

# python-3.12 迭代
git switch python-3.12 && \
  git reset --hard main && \
  git push origin python-3 --force.12 && \
  git switch main
```

### PowerShell

```powershell
# python-3.10 迭代
git switch python-3.10 ;`
  git reset --hard main ;`
  git push origin python-3 --force.10 ;`
  git switch main

# python-3.11 迭代
git switch python-3.11 ;`
  git reset --hard main ;`
  git push origin python-3 --force.11 ;`
  git switch main

# python-3.12 迭代
git switch python-3.12 ;`
  git reset --hard main ;`
  git push origin python-3 --force.12 ;`
  git switch main
```

## 镜像

Python 3.10：

- `registry.cn-qingdao.aliyuncs.com/wod/python:3.10-alpine`
- `registry.cn-qingdao.aliyuncs.com/wod/python:3.10-bookworm`

Python 3.11：

- `registry.cn-qingdao.aliyuncs.com/wod/python:3.11-alpine`
- `registry.cn-qingdao.aliyuncs.com/wod/python:3.11-bookworm`

Python 3.12：

- `registry.cn-qingdao.aliyuncs.com/wod/python:3.12-alpine`
- `registry.cn-qingdao.aliyuncs.com/wod/python:3.12-bookworm`

## 运行

```bash
docker run --rm -it \
  registry.cn-qingdao.aliyuncs.com/wod/python:3.12-bookworm \
  python --version
```
