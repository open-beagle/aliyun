# MySQL

## 上游镜像

- Docker Hub：https://hub.docker.com/_/mysql

## MySQL 8.4

### 迭代命令

```bash
git switch mysql-8 && \
  git merge main --ff-only && \
  git push origin mysql-8 && \
  git switch main
```

```powershell
git switch mysql-8 ;`
  git merge main --ff-only ;`
  git push origin mysql-8 ;`
  git switch main
```

### 概述

基于上游 `mysql` 镜像增加 `Asia/Shanghai` 时区配置。

GitHub Actions 工作流位于 `.github/workflows/mysql-8.yml`，推送 `mysql-8` 分支时触发构建。当前构建版本为 `8.4.9`，会构建 `linux/amd64` 和 `linux/arm64` 镜像，并推送到：

- `registry.cn-qingdao.aliyuncs.com/wod/mysql:8.4.9`
- `registry.cn-qingdao.aliyuncs.com/wod/mysql:8.4`
- `registry.cn-qingdao.aliyuncs.com/wod/mysql:8.4.9-amd64`
- `registry.cn-qingdao.aliyuncs.com/wod/mysql:8.4.9-arm64`
- `registry.cn-qingdao.aliyuncs.com/wod/mysql:8.4.9-bookworm`
- `registry.cn-qingdao.aliyuncs.com/wod/mysql:8.4-bookworm`

## MySQL 5.7

### 迭代命令

```bash
git switch mysql-5 && \
  git merge main --ff-only && \
  git push origin mysql-5 && \
  git switch main
```

```powershell
git switch mysql-5 ;`
  git merge main --ff-only ;`
  git push origin mysql-5 ;`
  git switch main
```

### 概述

基于上游 `mysql` 镜像增加 `Asia/Shanghai` 时区配置。

GitHub Actions 工作流位于 `.github/workflows/mysql-5.yml`，推送 `mysql-5` 分支时触发构建。当前构建版本为 `5.7.44`，仅构建 `linux/amd64` 镜像，并推送到：

- `registry.cn-qingdao.aliyuncs.com/wod/mysql:5.7.44`
- `registry.cn-qingdao.aliyuncs.com/wod/mysql:5.7`
- `registry.cn-qingdao.aliyuncs.com/wod/mysql:5.7.44-debian`
- `registry.cn-qingdao.aliyuncs.com/wod/mysql:5.7-debian`
