# VictoriaMetrics 多架构镜像构建与同步

本目录包含了用于在 2026 年同步和打包 **VictoriaMetrics** 系列组件至阿里云私有镜像服务的 Docker 编译定义和多架构流水线。

---

## 1. 组件与私有 Tags 设计（已消除 `-cluster` 冗余）

> [!IMPORTANT]
> **关于 `-cluster` 后缀的研判与消除：**
>
> 1. **上游命名原因**：VictoriaMetrics 官方对单机版（Standalone）和集群版（Cluster）进行了镜像分割。集群版的官方 Docker 镜像标签中强制带有 `-cluster` 后缀（例如 `victoriametrics/vminsert:v1.142.0-cluster`），用以区别于单机版。
> 2. **私有云精简设计**：在我们的私有云镜像仓库中，由于组件名称已按微服务独立拆分（`vmagent`, `vminsert`, `vmselect`, `vmstorage`），带有 `-cluster` 后缀会显得非常臃肿冗余，且增加了 Helm `values.yaml` 配置的复杂度。
> 3. **处理策略**：因此，我们在 GitHub Actions 流水线中**直接将 `-cluster` 后缀彻底干掉**！
>    - 上游拉取源：`victoriametrics/vminsert:v1.142.0-cluster`
>    - 私有库推送 Tag：
>      - **架构特定 Tag**：`registry.cn-qingdao.aliyuncs.com/wod/victoriametrics:vminsert-v1.142.0-amd64` 和 `-arm64`
>      - **聚合多架构 Tag**：`registry.cn-qingdao.aliyuncs.com/wod/victoriametrics:vminsert-v1.142.0` (由流水线自动使用 `docker buildx imagetools create` 进行聚合)

---

## 2. 上游链接与版本验证

为了方便跟踪和验证上游的最新发布以及 Docker 镜像 Tags，可以访问以下官方地址：

- **GitHub 官方 Releases**（获取最新版本及发布日志）：[VictoriaMetrics/VictoriaMetrics Releases](https://github.com/VictoriaMetrics/VictoriaMetrics/releases)
- **Docker Hub 官方镜像**（获取上游多架构基础镜像）：
  - `vmagent`: [victoriametrics/vmagent Docker Hub](https://hub.docker.com/r/victoriametrics/vmagent/tags)
  - `vminsert`: [victoriametrics/vminsert Docker Hub](https://hub.docker.com/r/victoriametrics/vminsert/tags)
  - [victoriametrics/vmselect Docker Hub](https://hub.docker.com/r/victoriametrics/vmselect/tags)
  - [victoriametrics/vmstorage Docker Hub](https://hub.docker.com/r/victoriametrics/vmstorage/tags)

---

## 3. 目录结构

```text
victoriametrics/
├── README.md               # 本文档（组件与编译说明及上游验证）
├── vmagent.dockerfile      # vmagent (采集端) 编译代理定义
├── vminsert.dockerfile     # vminsert (写入端) 编译代理定义
├── vmselect.dockerfile     # vmselect (查询端) 编译代理定义
└── vmstorage.dockerfile    # vmstorage (存储集群) 编译代理定义
```

---

## 4. 流水线工作流

所有组件的构建与推送任务均已高度自动化，由位于 [`.github/workflows/victoriametrics.yml`](../.github/workflows/victoriametrics.yml) 的 GitHub Actions 流水线托管。

### 触发机制

当推送/合并代码到 `victoriametrics` 分支时自动触发构建。

### 核心构建逻辑

对于每个组件，流水线会分步拉取 `amd64` 和 `arm64` 平台的基础镜像，打上精简的架构 Tag、配置时区并推送至阿里云：

- **基础时区配置**：各组件 Dockerfile 均已显式配置中国时区：`ENV TZ=Asia/Shanghai`。
- **AMD64 (x86_64) 构建**：`platforms: linux/amd64` -> 生成 `-amd64` 后缀镜像。
- **ARM64 (鲲鹏/信创) 构建**：`platforms: linux/arm64` -> 生成 `-arm64` 后缀镜像。
- **多架构 Manifest 聚合**：使用 `docker buildx imagetools create` 将以上两个单架构镜像聚合成一个不带架构后缀的多架构 Manifest Tag（例如 `vmagent-v1.142.0`）。

---

## 5. 迭代命令

```bash
git switch victoriametrics && \
  git merge main --ff-only && \
  git push origin victoriametrics && \
  git switch main
```

```powershell
git switch victoriametrics ;`
  git merge main --ff-only ;`
  git push origin victoriametrics ;`
  git switch main
```
