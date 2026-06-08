# Postgres

## 上游镜像

- Docker Hub：https://hub.docker.com/_/postgres
- 版本策略：https://www.postgresql.org/support/versioning/

## 版本选择

PostgreSQL 大版本通常每年发布一个，并维护 5 年。你从 PostgreSQL 11 开始接触这个数据库，项目上也仍有 PostgreSQL 11、12、13、14 的存量环境，所以这里把维护目标分为推荐维护版本和存量项目维护版本。

截至 2026-06-07，官方仍维护的版本为 PostgreSQL 14、15、16、17、18。其中 PostgreSQL 14 将在 2026-11-12 停止维护；PostgreSQL 13、12、11 已经停止官方维护，不建议用于新项目。

你主要使用 Go + GORM 开发后端，推荐维护以下版本：

- PostgreSQL 18.4：当前最新稳定大版本，适合作为新项目和前瞻验证版本，用来提前发现 GORM、驱动、SQL 行为或扩展兼容性问题。
- PostgreSQL 17.10：推荐作为新项目默认版本。版本新、生命周期长，适合大多数 Go 后端服务直接采用。
- PostgreSQL 16.14：推荐作为稳定生产版本。生态成熟、线上案例多，适合对稳定性优先、又希望保持较新特性的业务。
- PostgreSQL 15.18：推荐作为兼容保底版本。很多存量系统仍在使用，适合作为迁移、兼容测试和长期客户环境的兜底版本。

存量项目维护以下版本：

- PostgreSQL 14.23：仍处于官方维护期，但将在 2026-11-12 停止维护。适合已有 PG14 项目的短期维护和升级前过渡。
- PostgreSQL 13.23：已于 2025-11-13 停止官方维护。仅用于仍未迁移的存量项目、兼容测试和迁移演练。
- PostgreSQL 12.22：已于 2024-11-21 停止官方维护。仅用于历史项目过渡，不建议扩展新业务。
- PostgreSQL 11.22：已于 2023-11-09 停止官方维护。仅用于确有项目依赖的兜底镜像，应优先规划迁移。

## 分支和流水线约定

参考 MySQL 多版本维护方式，每个 PostgreSQL 大版本使用独立分支和独立 GitHub Actions 工作流：

- `postgres-18` 分支对应 `.github/workflows/postgres-18.yml`
- `postgres-17` 分支对应 `.github/workflows/postgres-17.yml`
- `postgres-16` 分支对应 `.github/workflows/postgres-16.yml`
- `postgres-15` 分支对应 `.github/workflows/postgres-15.yml`
- `postgres-14` 分支对应 `.github/workflows/postgres-14.yml`
- `postgres-13` 分支对应 `.github/workflows/postgres-13.yml`
- `postgres-12` 分支对应 `.github/workflows/postgres-12.yml`
- `postgres-11` 分支对应 `.github/workflows/postgres-11.yml`

原有 `.github/workflows/postgres.yml` 属于单版本流水线，现已拆分为上述 `postgres-版本.yml` 流水线。分支推送后触发对应版本构建。镜像默认推送到：

- `registry.cn-qingdao.aliyuncs.com/wod/postgres`
- `ghcr.io/open-beagle/postgres`

每个版本建议同时维护 Debian 默认变体和 Alpine 变体，并构建 `linux/amd64`、`linux/arm64`。

PostgreSQL 13、12、11 已经 EOL，流水线仍可保留，但只建议在存量项目需要时触发。对外使用时应明确这是兼容镜像，不承诺获得上游安全修复。

## Postgres 18

### 迭代命令

```bash
git switch postgres-18 && \
  git merge main --ff-only && \
  git push origin postgres-18 && \
  git switch main
```

```powershell
git switch postgres-18 ;`
  git merge main --ff-only ;`
  git push origin postgres-18 ;`
  git switch main
```

### 概述

基于上游 `postgres` 镜像补充镜像元数据。

GitHub Actions 工作流位于 `.github/workflows/postgres-18.yml`，推送 `postgres-18` 分支时触发构建。会构建 `linux/amd64` 和 `linux/arm64` 镜像，并推送到：

- `registry.cn-qingdao.aliyuncs.com/wod/postgres:18.4`
- `registry.cn-qingdao.aliyuncs.com/wod/postgres:18`
- `registry.cn-qingdao.aliyuncs.com/wod/postgres:18.4-amd64`
- `registry.cn-qingdao.aliyuncs.com/wod/postgres:18.4-arm64`

同时会构建 Alpine 变体，并推送到：

- `registry.cn-qingdao.aliyuncs.com/wod/postgres:18.4-alpine`
- `registry.cn-qingdao.aliyuncs.com/wod/postgres:18-alpine`
- `registry.cn-qingdao.aliyuncs.com/wod/postgres:18.4-alpine-amd64`
- `registry.cn-qingdao.aliyuncs.com/wod/postgres:18.4-alpine-arm64`

## Postgres 17

### 迭代命令

```bash
git switch postgres-17 && \
  git merge main --ff-only && \
  git push origin postgres-17 && \
  git switch main
```

```powershell
git switch postgres-17 ;`
  git merge main --ff-only ;`
  git push origin postgres-17 ;`
  git switch main
```

### 概述

基于上游 `postgres` 镜像补充镜像元数据。

GitHub Actions 工作流位于 `.github/workflows/postgres-17.yml`，推送 `postgres-17` 分支时触发构建。会构建 `linux/amd64` 和 `linux/arm64` 镜像，并推送到：

- `registry.cn-qingdao.aliyuncs.com/wod/postgres:17.10`
- `registry.cn-qingdao.aliyuncs.com/wod/postgres:17`
- `registry.cn-qingdao.aliyuncs.com/wod/postgres:17.10-amd64`
- `registry.cn-qingdao.aliyuncs.com/wod/postgres:17.10-arm64`

同时会构建 Alpine 变体，并推送到：

- `registry.cn-qingdao.aliyuncs.com/wod/postgres:17.10-alpine`
- `registry.cn-qingdao.aliyuncs.com/wod/postgres:17-alpine`
- `registry.cn-qingdao.aliyuncs.com/wod/postgres:17.10-alpine-amd64`
- `registry.cn-qingdao.aliyuncs.com/wod/postgres:17.10-alpine-arm64`

## Postgres 16

### 迭代命令

```bash
git switch postgres-16 && \
  git merge main --ff-only && \
  git push origin postgres-16 && \
  git switch main
```

```powershell
git switch postgres-16 ;`
  git merge main --ff-only ;`
  git push origin postgres-16 ;`
  git switch main
```

### 概述

基于上游 `postgres` 镜像补充镜像元数据。

GitHub Actions 工作流位于 `.github/workflows/postgres-16.yml`，推送 `postgres-16` 分支时触发构建。会构建 `linux/amd64` 和 `linux/arm64` 镜像，并推送到：

- `registry.cn-qingdao.aliyuncs.com/wod/postgres:16.14`
- `registry.cn-qingdao.aliyuncs.com/wod/postgres:16`
- `registry.cn-qingdao.aliyuncs.com/wod/postgres:16.14-amd64`
- `registry.cn-qingdao.aliyuncs.com/wod/postgres:16.14-arm64`

同时会构建 Alpine 变体，并推送到：

- `registry.cn-qingdao.aliyuncs.com/wod/postgres:16.14-alpine`
- `registry.cn-qingdao.aliyuncs.com/wod/postgres:16-alpine`
- `registry.cn-qingdao.aliyuncs.com/wod/postgres:16.14-alpine-amd64`
- `registry.cn-qingdao.aliyuncs.com/wod/postgres:16.14-alpine-arm64`

## Postgres 15

### 迭代命令

```bash
git switch postgres-15 && \
  git merge main --ff-only && \
  git push origin postgres-15 && \
  git switch main
```

```powershell
git switch postgres-15 ;`
  git merge main --ff-only ;`
  git push origin postgres-15 ;`
  git switch main
```

### 概述

基于上游 `postgres` 镜像补充镜像元数据。

GitHub Actions 工作流位于 `.github/workflows/postgres-15.yml`，推送 `postgres-15` 分支时触发构建。会构建 `linux/amd64` 和 `linux/arm64` 镜像，并推送到：

- `registry.cn-qingdao.aliyuncs.com/wod/postgres:15.18`
- `registry.cn-qingdao.aliyuncs.com/wod/postgres:15`
- `registry.cn-qingdao.aliyuncs.com/wod/postgres:15.18-amd64`
- `registry.cn-qingdao.aliyuncs.com/wod/postgres:15.18-arm64`

同时会构建 Alpine 变体，并推送到：

- `registry.cn-qingdao.aliyuncs.com/wod/postgres:15.18-alpine`
- `registry.cn-qingdao.aliyuncs.com/wod/postgres:15-alpine`
- `registry.cn-qingdao.aliyuncs.com/wod/postgres:15.18-alpine-amd64`
- `registry.cn-qingdao.aliyuncs.com/wod/postgres:15.18-alpine-arm64`

## Postgres 14

### 迭代命令

```bash
git switch postgres-14 && \
  git merge main --ff-only && \
  git push origin postgres-14 && \
  git switch main
```

```powershell
git switch postgres-14 ;`
  git merge main --ff-only ;`
  git push origin postgres-14 ;`
  git switch main
```

### 概述

基于上游 `postgres` 镜像补充镜像元数据。

GitHub Actions 工作流位于 `.github/workflows/postgres-14.yml`，推送 `postgres-14` 分支时触发构建。当前构建版本为 `14.23`，该大版本将在 2026-11-12 停止官方维护。会构建 `linux/amd64` 和 `linux/arm64` 镜像，并推送到：

- `registry.cn-qingdao.aliyuncs.com/wod/postgres:14.23`
- `registry.cn-qingdao.aliyuncs.com/wod/postgres:14`
- `registry.cn-qingdao.aliyuncs.com/wod/postgres:14.23-amd64`
- `registry.cn-qingdao.aliyuncs.com/wod/postgres:14.23-arm64`

同时会构建 Alpine 变体，并推送到：

- `registry.cn-qingdao.aliyuncs.com/wod/postgres:14.23-alpine`
- `registry.cn-qingdao.aliyuncs.com/wod/postgres:14-alpine`
- `registry.cn-qingdao.aliyuncs.com/wod/postgres:14.23-alpine-amd64`
- `registry.cn-qingdao.aliyuncs.com/wod/postgres:14.23-alpine-arm64`

## Postgres 13

### 迭代命令

```bash
git switch postgres-13 && \
  git merge main --ff-only && \
  git push origin postgres-13 && \
  git switch main
```

```powershell
git switch postgres-13 ;`
  git merge main --ff-only ;`
  git push origin postgres-13 ;`
  git switch main
```

### 概述

基于上游 `postgres` 镜像补充镜像元数据。

GitHub Actions 工作流位于 `.github/workflows/postgres-13.yml`，推送 `postgres-13` 分支时触发构建。最终维护版本为 `13.23`，该大版本已于 2025-11-13 停止官方维护。会面向存量项目构建 `linux/amd64` 和 `linux/arm64` 镜像，并推送到：

- `registry.cn-qingdao.aliyuncs.com/wod/postgres:13.23`
- `registry.cn-qingdao.aliyuncs.com/wod/postgres:13`
- `registry.cn-qingdao.aliyuncs.com/wod/postgres:13.23-amd64`
- `registry.cn-qingdao.aliyuncs.com/wod/postgres:13.23-arm64`

同时会构建 Alpine 变体，并推送到：

- `registry.cn-qingdao.aliyuncs.com/wod/postgres:13.23-alpine`
- `registry.cn-qingdao.aliyuncs.com/wod/postgres:13-alpine`
- `registry.cn-qingdao.aliyuncs.com/wod/postgres:13.23-alpine-amd64`
- `registry.cn-qingdao.aliyuncs.com/wod/postgres:13.23-alpine-arm64`

## Postgres 12

### 迭代命令

```bash
git switch postgres-12 && \
  git merge main --ff-only && \
  git push origin postgres-12 && \
  git switch main
```

```powershell
git switch postgres-12 ;`
  git merge main --ff-only ;`
  git push origin postgres-12 ;`
  git switch main
```

### 概述

基于上游 `postgres` 镜像补充镜像元数据。

GitHub Actions 工作流位于 `.github/workflows/postgres-12.yml`，推送 `postgres-12` 分支时触发构建。最终维护版本为 `12.22`，该大版本已于 2024-11-21 停止官方维护。会面向存量项目构建 `linux/amd64` 和 `linux/arm64` 镜像，并推送到：

- `registry.cn-qingdao.aliyuncs.com/wod/postgres:12.22`
- `registry.cn-qingdao.aliyuncs.com/wod/postgres:12`
- `registry.cn-qingdao.aliyuncs.com/wod/postgres:12.22-amd64`
- `registry.cn-qingdao.aliyuncs.com/wod/postgres:12.22-arm64`

同时会构建 Alpine 变体，并推送到：

- `registry.cn-qingdao.aliyuncs.com/wod/postgres:12.22-alpine`
- `registry.cn-qingdao.aliyuncs.com/wod/postgres:12-alpine`
- `registry.cn-qingdao.aliyuncs.com/wod/postgres:12.22-alpine-amd64`
- `registry.cn-qingdao.aliyuncs.com/wod/postgres:12.22-alpine-arm64`

## Postgres 11

### 迭代命令

```bash
git switch postgres-11 && \
  git merge main --ff-only && \
  git push origin postgres-11 && \
  git switch main
```

```powershell
git switch postgres-11 ;`
  git merge main --ff-only ;`
  git push origin postgres-11 ;`
  git switch main
```

### 概述

基于上游 `postgres` 镜像补充镜像元数据。

GitHub Actions 工作流位于 `.github/workflows/postgres-11.yml`，推送 `postgres-11` 分支时触发构建。最终维护版本为 `11.22`，该大版本已于 2023-11-09 停止官方维护。会面向存量项目构建 `linux/amd64` 和 `linux/arm64` 镜像，并推送到：

- `registry.cn-qingdao.aliyuncs.com/wod/postgres:11.22`
- `registry.cn-qingdao.aliyuncs.com/wod/postgres:11`
- `registry.cn-qingdao.aliyuncs.com/wod/postgres:11.22-amd64`
- `registry.cn-qingdao.aliyuncs.com/wod/postgres:11.22-arm64`

同时会构建 Alpine 变体，并推送到：

- `registry.cn-qingdao.aliyuncs.com/wod/postgres:11.22-alpine`
- `registry.cn-qingdao.aliyuncs.com/wod/postgres:11-alpine`
- `registry.cn-qingdao.aliyuncs.com/wod/postgres:11.22-alpine-amd64`
- `registry.cn-qingdao.aliyuncs.com/wod/postgres:11.22-alpine-arm64`
