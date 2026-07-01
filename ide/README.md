# Ide

## 迭代命令

### Bash

```bash
# ide 迭代
git switch ide && \
  git merge main --ff-only && \
  git push origin ide && \
  git switch main
```

### PowerShell

```powershell
# ide 迭代
git switch ide ;`
  git merge main --ff-only ;`
  git push origin ide ;`
  git switch main
```

## 概述

本目录用于构建 Ide 镜像，基于上游项目进行定制开发，主要集成了 Beagle 内部环境的配置（如加速源、CA 证书、时区等）。

推送到 `ide` 分支时，会触发相应的 GitHub Actions 工作流构建镜像并推送到阿里云容器镜像服务。
