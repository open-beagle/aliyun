# VictoriaMetrics 多架构镜像构建与同步

本目录包含了用于在 2026 年同步和打包 **VictoriaMetrics** 系列组件至阿里云私有镜像服务的 Docker 编译定义和多架构流水线。

---

## 1. 组件与私有 Tags 设计（已消除 `-cluster` 冗余）

> [!IMPORTANT]
> **关于 `-cluster` 后缀的研判与消除：**
> 1. **上游命名原因**：VictoriaMetrics 官方对单机版（Standalone）和集群版（Cluster）进行了镜像分割。集群版的官方 Docker 镜像标签中强制带有 `-cluster` 后缀（例如 `victoriametrics/vminsert:v1.101.0-cluster`），用以区别于单机版。
> 2. **私有云精简设计**：在我们的私有云镜像仓库中，由于组件名称已按微服务独立拆分（`vmagent`, `vminsert`, `vmselect`, `vmstorage`），带有 `-cluster` 后缀会显得非常臃肿冗余，且增加了 Helm `values.yaml` 配置的复杂度。
> 3. **处理策略**：因此，我们在 GitHub Actions 流水线中**直接将 `-cluster` 后缀彻底干掉**！
>    * 上游拉取源：`victoriametrics/vminsert:v1.101.0-cluster`
>    * 私有库推送 Tag：`registry.cn-qingdao.aliyuncs.com/wod/victoriametrics:vminsert-v1.101.0-amd64` (及 `-arm64`)

---

## 2. 目录结构

```text
victoriametrics/
├── README.md               # 本文档（组件与编译说明）
├── vmagent.dockerfile      # vmagent (采集端) 编译代理定义
├── vminsert.dockerfile     # vminsert (写入端) 编译代理定义
├── vmselect.dockerfile     # vmselect (查询端) 编译代理定义
└── vmstorage.dockerfile    # vmstorage (存储集群) 编译代理定义
```

---

## 3. 流水线工作流

所有组件的构建与推送任务均已高度自动化，由位于 [`.github/workflows/victoriametrics.yml`](../.github/workflows/victoriametrics.yml) 的 GitHub Actions 流水线托管。

### 触发机制
当推送/合并代码到 `victoriametrics` 分支时自动触发构建。

### 核心构建逻辑
对于每个组件，流水线会分步拉取 `amd64` 和 `arm64` 平台的基础镜像，打上精简的架构 Tag 并推送至阿里云：
* **AMD64 (x86_64) 构建**：`platforms: linux/amd64` -> 生成 `-amd64` 后缀镜像。
* **ARM64 (鲲鹏/信创) 构建**：`platforms: linux/arm64` -> 生成 `-arm64` 后缀镜像。
