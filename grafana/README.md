# Grafana 组件多架构镜像构建与同步

本目录包含了用于在 2026 年同步和打包 **Grafana** 组件至阿里云私有镜像服务的 Docker 编译定义和多架构流水线。

---

## 1. 组件与私有 Tags 设计

### Grafana

- **上游拉取源**：`grafana/grafana:11.6.14`
- **私有库推送 Tag**：
  - **架构特定 Tag**：`registry.cn-qingdao.aliyuncs.com/wod/grafana:11.6.14-amd64` 和 `-arm64`
  - **聚合多架构 Tag**：`registry.cn-qingdao.aliyuncs.com/wod/grafana:11.6.14`

### Tempo

- **上游拉取源**：`grafana/tempo:3.0.2`
- **私有库推送 Tag**：
  - **架构特定 Tag**：`registry.cn-qingdao.aliyuncs.com/wod/tempo:3.0.2-amd64` 和 `-arm64`
  - **聚合多架构 Tag**：`registry.cn-qingdao.aliyuncs.com/wod/tempo:3.0.2`

---

## 2. 上游链接与版本验证

为了方便跟踪和验证上游发布以及 Docker 镜像 Tags，可以访问以下官方地址：

- **GitHub 官方 Releases**：[grafana/grafana Releases](https://github.com/grafana/grafana/releases)
- **Docker Hub 官方镜像**：[grafana/grafana Docker Hub](https://hub.docker.com/r/grafana/grafana/tags)
- **Tempo GitHub Releases**：[grafana/tempo Releases](https://github.com/grafana/tempo/releases)
- **Tempo Docker Hub 镜像**：[grafana/tempo Docker Hub](https://hub.docker.com/r/grafana/tempo/tags)

Tempo 版本以 GitHub Releases 页面标记的 Latest Release 为准；Docker Hub 的最近 Tag 列表可能优先显示 `main-*` 等持续构建标签。

---

## 3. 目录结构

```text
grafana/
├── README.md               # 本文档（组件与编译说明及上游验证）
├── grafana.dockerfile      # grafana 编译代理定义
└── tempo.dockerfile        # tempo 编译代理定义
```

---

## 4. 流水线工作流

构建与推送任务均已高度自动化，由 GitHub Actions 流水线托管。

| 组件    | Workflow                                                           | 触发分支        |
| ------- | ------------------------------------------------------------------ | --------------- |
| Grafana | [`.github/workflows/grafana.yml`](../.github/workflows/grafana.yml) | `grafana`       |
| Tempo   | [`.github/workflows/grafana-tempo.yml`](../.github/workflows/grafana-tempo.yml) | `grafana-tempo` |

### 触发机制

当推送/合并代码到对应组件分支时自动触发构建。

### 核心构建逻辑

流水线会分步拉取 `amd64` 和 `arm64` 平台的基础镜像，打上架构 Tag、配置时区并推送至阿里云：

- **基础时区配置**：Dockerfile 已显式配置中国时区：`ENV TZ=Asia/Shanghai`。
- **AMD64 (x86_64) 构建**：`platforms: linux/amd64` -> 生成 `-amd64` 后缀镜像。
- **ARM64 (鲲鹏/信创) 构建**：`platforms: linux/arm64` -> 生成 `-arm64` 后缀镜像。
- **多架构 Manifest 聚合**：使用 `docker buildx imagetools create` 将以上两个单架构镜像聚合成一个不带架构后缀的多架构 Manifest Tag。

---

## 5. 迭代命令

```bash
git switch grafana && \
  git merge main --ff-only && \
  git push origin grafana && \
  git switch main

git switch grafana-tempo && \
  git merge main --ff-only && \
  git push origin grafana-tempo && \
  git switch main
```

```powershell
git switch grafana ;`
  git merge main --ff-only ;`
  git push origin grafana ;`
  git switch main

git switch grafana-tempo ;`
  git merge main --ff-only ;`
  git push origin grafana-tempo ;`
  git switch main
```
