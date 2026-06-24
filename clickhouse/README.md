# ClickHouse

## Github 地址

- 上游项目：https://github.com/ClickHouse/ClickHouse

## 迭代命令

```bash
git switch clickhouse && \
  git merge main --ff-only && \
  git push origin clickhouse && \
  git switch main
```

```powershell
git switch clickhouse ;`
  git merge main --ff-only ;`
  git push origin clickhouse ;`
  git switch main
```

## 概述

本目录用于构建 ClickHouse Server 镜像，基于上游 `clickhouse/clickhouse-server` 镜像增加 `Asia/Shanghai` 时区配置。

GitHub Actions 工作流位于 `.github/workflows/clickhouse.yml`，推送 `clickhouse` 分支时触发构建。当前构建版本为 `25.5.6`，会构建多架构及单架构（`linux/amd64` 和 `linux/arm64`）镜像，并推送到：

**多架构镜像（自动按运行环境选择架构）**：
- `registry.cn-qingdao.aliyuncs.com/wod/clickhouse:server-25.5.6`
- `ghcr.io/open-beagle/clickhouse:server-25.5.6`

**指定架构镜像**：
- `registry.cn-qingdao.aliyuncs.com/wod/clickhouse:server-25.5.6-amd64`
- `ghcr.io/open-beagle/clickhouse:server-25.5.6-amd64`
- `registry.cn-qingdao.aliyuncs.com/wod/clickhouse:server-25.5.6-arm64`
- `ghcr.io/open-beagle/clickhouse:server-25.5.6-arm64`
