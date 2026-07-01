# Python

## 迭代命令

### Bash

```bash
# python 迭代
git switch python && \
  git merge main --ff-only && \
  git push origin python && \
  git switch main
```

### PowerShell

```powershell
# python 迭代
git switch python ;`
  git merge main --ff-only ;`
  git push origin python ;`
  git switch main
```

## 概述

本目录用于构建 Python 镜像，基于上游项目进行定制开发，主要集成了 Beagle 内部环境的配置（如加速源、CA 证书、时区等）。

推送到 `python` 分支时，会触发相应的 GitHub Actions 工作流构建镜像并推送到阿里云容器镜像服务。
