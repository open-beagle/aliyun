# PostGIS

## 上游镜像

- Docker Hub：https://hub.docker.com/r/postgis/postgis
- Dockerfile：https://github.com/postgis/docker-postgis

本仓库不直接复用 `postgis/postgis` 镜像，而是在现有 PostgreSQL 镜像仓库下维护 PostGIS 变体，统一推送到：

```text
registry.cn-qingdao.aliyuncs.com/wod/postgres
```

标签使用 `PostgreSQL大版本-postgisPostGIS小版本`：

```text
registry.cn-qingdao.aliyuncs.com/wod/postgres:12-postgis3.6
registry.cn-qingdao.aliyuncs.com/wod/postgres:16-postgis3.6
```

## 维护策略

PostgreSQL 11 + PostGIS 2.5 已经从上游 `docker-postgis` 维护范围移除，不再新增 arm64 镜像。现有 `registry.cn-qingdao.aliyuncs.com/wod/postgis:11-2.5` 仅作为存量 amd64 兜底，不在本轮新矩阵内继续扩展。

PostgreSQL 12 也统一提供 PostGIS 3.6 镜像，用来替换项目里曾经使用的第三方 arm64 镜像，并在应用侧自行处理 PostGIS 2.5 到 3.6 的扩展升级：

```text
swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/duvel/postgis:12-2.5-arm64-Linuxarm64
```

PostgreSQL 12 使用本仓库同步到 `ghcr.io/open-beagle/postgres:12` 的 PostgreSQL 镜像作为 base，当前是 Debian 12 bookworm + PostgreSQL 12.22。PostgreSQL 13-18 使用本仓库同步到 GHCR 的 Debian 13 trixie base。

构建时优先从 GHCR 拉取本仓库同步维护的 PostgreSQL base：

```text
ghcr.io/open-beagle/postgres:12
ghcr.io/open-beagle/postgres:16
```

PostgreSQL 12 使用 PGDG `bookworm-pgdg` 仓库中同时提供 amd64/arm64 的 PostGIS 3.6 包，当前锁定版本为：

```text
3.6.3+dfsg-1.pgdg12+1
```

PostgreSQL 13-18 使用 PGDG `trixie-pgdg` 仓库中同时提供 amd64/arm64 的 PostGIS 3.6 包，当前锁定版本为：

```text
3.6.3+dfsg-1.pgdg13+1
```

## 版本矩阵

| PostgreSQL | PostGIS | 包来源                | 分支         | 工作流                             |
| ---------- | ------- | --------------------- | ------------ | ---------------------------------- |
| 12.22      | 3.6.3   | `bookworm-pgdg`       | `postgis-12` | `.github/workflows/postgis-12.yml` |
| 13.23      | 3.6.3   | `trixie-pgdg`         | `postgis-13` | `.github/workflows/postgis-13.yml` |
| 14.23      | 3.6.3   | `trixie-pgdg`         | `postgis-14` | `.github/workflows/postgis-14.yml` |
| 15.18      | 3.6.3   | `trixie-pgdg`         | `postgis-15` | `.github/workflows/postgis-15.yml` |
| 16.14      | 3.6.3   | `trixie-pgdg`         | `postgis-16` | `.github/workflows/postgis-16.yml` |
| 17.10      | 3.6.3   | `trixie-pgdg`         | `postgis-17` | `.github/workflows/postgis-17.yml` |
| 18.4       | 3.6.3   | `trixie-pgdg`         | `postgis-18` | `.github/workflows/postgis-18.yml` |

PG12 已经停止 PostgreSQL 官方维护，保留它是为了项目迁移过渡；PostGIS 插件统一使用 3.6，不再维护新的 PG12 + PostGIS 2.5 arm64 镜像。

## 镜像标签

每个版本都会推送一个多架构标签和两个架构固定标签。

| PostgreSQL | 多架构标签      | amd64                 | arm64                 |
| ---------- | --------------- | --------------------- | --------------------- |
| 12         | `12-postgis3.6` | `12-postgis3.6-amd64` | `12-postgis3.6-arm64` |
| 13         | `13-postgis3.6` | `13-postgis3.6-amd64` | `13-postgis3.6-arm64` |
| 14         | `14-postgis3.6` | `14-postgis3.6-amd64` | `14-postgis3.6-arm64` |
| 15         | `15-postgis3.6` | `15-postgis3.6-amd64` | `15-postgis3.6-arm64` |
| 16         | `16-postgis3.6` | `16-postgis3.6-amd64` | `16-postgis3.6-arm64` |
| 17         | `17-postgis3.6` | `17-postgis3.6-amd64` | `17-postgis3.6-arm64` |
| 18         | `18-postgis3.6` | `18-postgis3.6-amd64` | `18-postgis3.6-arm64` |

完整镜像名示例：

```text
registry.cn-qingdao.aliyuncs.com/wod/postgres:12-postgis3.6
registry.cn-qingdao.aliyuncs.com/wod/postgres:12-postgis3.6-arm64
registry.cn-qingdao.aliyuncs.com/wod/postgres:18-postgis3.6
```

## 迭代命令

每个版本使用独立分支。以 PG16 为例：

```bash
git switch postgis-16 && \
  git merge main --ff-only && \
  git push origin postgis-16 && \
  git switch main
```

```powershell
git switch postgis-16 ;`
  git merge main --ff-only ;`
  git push origin postgis-16 ;`
  git switch main
```

PG12-18 对应替换分支名即可：

```text
postgis-12
postgis-13
postgis-14
postgis-15
postgis-16
postgis-17
postgis-18
```

## 构建参数

PG12 复用本仓库已经维护的 PostgreSQL 12 Debian 镜像，只安装 PostGIS：

```yaml
BASE_IMAGE: ghcr.io/open-beagle/postgres:12
DEBIAN_SUITE: bookworm
POSTGRES_PACKAGE_VERSION: default
POSTGIS_PACKAGE_VERSION: 3.6.3+dfsg-1.pgdg12+1
POSTGIS_MAJOR: "3"
ARCHIVE_APT: "false"
```

PG13-18 复用本仓库已经维护的 PostgreSQL Debian 镜像，只安装 PostGIS：

```yaml
BASE_IMAGE: ghcr.io/open-beagle/postgres:16
DEBIAN_SUITE: trixie
POSTGRES_PACKAGE_VERSION: default
POSTGIS_PACKAGE_VERSION: 3.6.3+dfsg-1.pgdg13+1
POSTGIS_MAJOR: "3"
ARCHIVE_APT: "false"
```

## 本地验证

PG12 示例：

```bash
podman build --platform linux/amd64 \
  --build-arg BASE=ghcr.io/open-beagle/postgres:12 \
  --build-arg DEBIAN_SUITE=bookworm \
  --build-arg POSTGRES_PACKAGE_VERSION=default \
  --build-arg POSTGIS_PACKAGE_VERSION=3.6.3+dfsg-1.pgdg12+1 \
  --build-arg POSTGIS_MAJOR=3 \
  --build-arg ARCHIVE_APT=false \
  -f postgis/dockerfile \
  -t local/postgres:12-postgis3.6-test .
```

PG16 示例：

```bash
podman build --platform linux/amd64 \
  --build-arg BASE=ghcr.io/open-beagle/postgres:16 \
  --build-arg DEBIAN_SUITE=trixie \
  --build-arg POSTGRES_PACKAGE_VERSION=default \
  --build-arg POSTGIS_PACKAGE_VERSION=3.6.3+dfsg-1.pgdg13+1 \
  --build-arg POSTGIS_MAJOR=3 \
  --build-arg ARCHIVE_APT=false \
  -f postgis/dockerfile \
  -t local/postgres:16-postgis3.6-test .
```

容器初始化后检查 PostGIS：

```bash
psql -U postgres -d postgres -c 'SELECT postgis_lib_version(), PostGIS_Full_Version();'
psql -U postgres -d template_postgis -c 'SELECT postgis_lib_version(), PostGIS_Full_Version();'
```

## 迁移建议

PG12 arm64 从第三方镜像：

```text
swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/duvel/postgis:12-2.5-arm64-Linuxarm64
```

替换为：

```text
registry.cn-qingdao.aliyuncs.com/wod/postgres:12-postgis3.6
```

如果需要固定架构，可以显式使用：

```text
registry.cn-qingdao.aliyuncs.com/wod/postgres:12-postgis3.6-arm64
```

新项目优先选择仍在 PostgreSQL 官方维护期内的大版本，例如：

```text
registry.cn-qingdao.aliyuncs.com/wod/postgres:16-postgis3.6
registry.cn-qingdao.aliyuncs.com/wod/postgres:17-postgis3.6
registry.cn-qingdao.aliyuncs.com/wod/postgres:18-postgis3.6
```
