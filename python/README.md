# Python

## Docker Hub 地址

- 上游镜像：https://hub.docker.com/_/python

本目录用于构建 Python 镜像，基于上游项目进行定制开发，主要集成了 Beagle 内部环境的配置（如加速源、CA 证书、时区等），并预装了 poetry。

推送到 `python-3.x` 系列分支（例如 `python-3.12`）时，会触发相应的 GitHub Actions 工作流构建镜像并推送到阿里云容器镜像服务。

## 迭代命令

### Bash

```bash
# python-3.10 迭代
git switch python-3.10 && \
  git merge main --ff-only && \
  git push origin python-3.10 && \
  git switch main

# python-3.11 迭代
git switch python-3.11 && \
  git merge main --ff-only && \
  git push origin python-3.11 && \
  git switch main

# python-3.12 迭代
git switch python-3.12 && \
  git merge main --ff-only && \
  git push origin python-3.12 && \
  git switch main
```

### PowerShell

```powershell
# python-3.10 迭代
git switch python-3.10 ;`
  git merge main --ff-only ;`
  git push origin python-3.10 ;`
  git switch main

# python-3.11 迭代
git switch python-3.11 ;`
  git merge main --ff-only ;`
  git push origin python-3.11 ;`
  git switch main

# python-3.12 迭代
git switch python-3.12 ;`
  git merge main --ff-only ;`
  git push origin python-3.12 ;`
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
