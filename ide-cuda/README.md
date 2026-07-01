# Ide-cuda

## 迭代命令

### Bash

```bash
# ide-cuda 迭代
git switch ide-cuda && \
  git merge main --ff-only && \
  git push origin ide-cuda && \
  git switch main
```

### PowerShell

```powershell
# ide-cuda 迭代
git switch ide-cuda ;`
  git merge main --ff-only ;`
  git push origin ide-cuda ;`
  git switch main
```

## 概述

本目录用于构建 Ide-cuda 镜像，基于上游项目进行定制开发，主要集成了 Beagle 内部环境的配置（如加速源、CA 证书、时区等）。

推送到 `ide-cuda` 分支时，会触发相应的 GitHub Actions 工作流构建镜像并推送到阿里云容器镜像服务。
