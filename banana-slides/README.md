# Banana Slides

## Github 地址

- 上游镜像：https://hub.docker.com/r/anoinex/banana-slides-frontend
- 上游镜像：https://hub.docker.com/r/anoinex/banana-slides-backend

## 迭代命令

```bash
git switch banana-slides && \
  git merge main --ff-only && \
  git push origin banana-slides && \
  git switch main
```

```powershell
git switch banana-slides ;`
  git merge main --ff-only ;`
  git push origin banana-slides ;`
  git switch main
```

## 概述

本目录用于构建 Banana Slides 前端和后端镜像，基于上游 `anoinex/banana-slides-frontend` 与 `anoinex/banana-slides-backend` 镜像补充维护者、版本标签和 `Asia/Shanghai` 时区配置。

GitHub Actions 工作流位于 `.github/workflows/banana-slides.yml`，推送 `banana-slides` 分支时触发构建。当前前端和后端版本均为 `latest`，构建 `linux/amd64` 镜像并推送到：

- `registry.cn-qingdao.aliyuncs.com/wod/banana-slides:frontend-latest`
- `registry.cn-qingdao.aliyuncs.com/wod/banana-slides:backend-latest`
- `ghcr.io/open-beagle/banana-slides:frontend-latest`
- `ghcr.io/open-beagle/banana-slides:backend-latest`
