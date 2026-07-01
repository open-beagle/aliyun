# Lada

## 迭代命令

### Bash

```bash
# lada 迭代
git switch lada && \
  git merge main --ff-only && \
  git push origin lada && \
  git switch main
```

### PowerShell

```powershell
# lada 迭代
git switch lada ;`
  git merge main --ff-only ;`
  git push origin lada ;`
  git switch main
```

## 概述

本目录用于构建 Lada 镜像，基于上游项目进行定制开发，主要集成了 Beagle 内部环境的配置（如加速源、CA 证书、时区等）。

推送到 `lada` 分支时，会触发相应的 GitHub Actions 工作流构建镜像并推送到阿里云容器镜像服务。
