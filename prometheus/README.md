# Prometheus 组件多架构镜像构建与同步

本目录包含了用于在 2026 年同步和打包 **Prometheus 生态核心组件** 至阿里云私有镜像服务的 Docker 编译定义和多架构流水线。

---

## 1. 组件与私有 Tags 设计（K8s v1.32.10 兼容）

为了完美兼容目标 Kubernetes **`v1.32.10`** 平台，本流水线对核心组件的版本进行了精确对齐。同时采用精简的多架构 Tag 设计，并在构建阶段分别打上特定平台后缀，最后使用 `docker buildx imagetools` 聚合成多架构 Tag。

- **架构特定 Tag**：
  - `registry.cn-qingdao.aliyuncs.com/wod/prometheus:alertmanager-v0.32.1-amd64` 和 `-arm64`
  - `registry.cn-qingdao.aliyuncs.com/wod/prometheus:node-exporter-v1.8.1-amd64` 和 `-arm64`
  - `registry.cn-qingdao.aliyuncs.com/wod/prometheus:kube-state-metrics-v2.14.0-amd64` 和 `-arm64`
  - `registry.cn-qingdao.aliyuncs.com/wod/prometheus:k8s-sidecar-2.7.3-amd64` 和 `-arm64`
- **聚合多架构 Tag**：
  - `registry.cn-qingdao.aliyuncs.com/wod/prometheus:alertmanager-v0.32.1`
  - `registry.cn-qingdao.aliyuncs.com/wod/prometheus:node-exporter-v1.8.1`
  - `registry.cn-qingdao.aliyuncs.com/wod/prometheus:kube-state-metrics-v2.14.0`
  - `registry.cn-qingdao.aliyuncs.com/wod/prometheus:k8s-sidecar-2.7.3`

| 组件名称 | 上游基础拉取源 | 聚合多架构 Tag | 兼容说明 |
| :--- | :--- | :--- | :--- |
| **Alertmanager** | `quay.io/prometheus/alertmanager:v0.32.1` | `registry.cn-qingdao.aliyuncs.com/wod/prometheus:alertmanager-v0.32.1` | 中心端与边缘端的高级告警收拢 |
| **Node Exporter** | `quay.io/prometheus/node-exporter:v1.8.1` | `registry.cn-qingdao.aliyuncs.com/wod/prometheus:node-exporter-v1.8.1` | 宿主机底层硬件、CPU/内存/磁盘物理指标暴露 |
| **Kube State Metrics** | `registry.k8s.io/kube-state-metrics/kube-state-metrics:v2.14.0` | `registry.cn-qingdao.aliyuncs.com/wod/prometheus:kube-state-metrics-v2.14.0` | **深度适配 K8s v1.32.x API 组**，防范旧版（v2.12及以下）在 1.32 API 废弃阶段的解析故障 |
| **k8s-sidecar** | `kiwigrid/k8s-sidecar:2.7.3` | `registry.cn-qingdao.aliyuncs.com/wod/prometheus:k8s-sidecar-2.7.3` | 自动配置加载 sidecar (Grafana 资源加载等) |

---

## 2. 上游链接与版本验证

为了方便跟踪和验证上游的最新发布以及 Docker 镜像 Tags，可以访问以下官方地址：

- **GitHub 官方 Releases**：
  - [prometheus/alertmanager Releases](https://github.com/prometheus/alertmanager/releases)
  - [prometheus/node_exporter Releases](https://github.com/prometheus/node_exporter/releases)
  - [kubernetes/kube-state-metrics Releases](https://github.com/kubernetes/kube-state-metrics/releases)
- **Docker Hub / Quay 官方镜像**：
  - `alertmanager`: [quay.io/prometheus/alertmanager Tags](https://quay.io/repository/prometheus/alertmanager?tab=tags)
  - `node-exporter`: [quay.io/prometheus/node-exporter Tags](https://quay.io/repository/prometheus/node-exporter?tab=tags)
  - `kube-state-metrics`: [registry.k8s.io kube-state-metrics](https://console.cloud.google.com/gcr/images/k8s-artifacts-prod/us/kube-state-metrics/kube-state-metrics)
  - `k8s-sidecar`: [kiwigrid/k8s-sidecar Tags](https://quay.io/repository/kiwigrid/k8s-sidecar?tab=tags)

---

## 3. 目录结构

```text
prometheus/
├── README.md                          # 本文档（组件与编译说明及上游验证）
├── alertmanager.dockerfile            # alertmanager 编译代理定义
├── kube-state-metrics.dockerfile     # kube-state-metrics 编译代理定义
├── node-exporter.dockerfile           # node-exporter 编译代理定义
└── k8s-sidecar.dockerfile             # k8s-sidecar 编译代理定义
```

---

## 4. 流水线工作流

所有组件的构建与推送任务均已高度自动化，由位于 [`.github/workflows/prometheus.yml`](../.github/workflows/prometheus.yml) 的 GitHub Actions 流水线托管。

### 触发机制

当推送/合并代码到 `prometheus` 分支时自动触发构建。

### 核心构建逻辑

对于每个组件，流水线会分步拉取 `amd64` 和 `arm64` 平台的基础镜像，打上精简的架构 Tag、配置时区并推送至阿里云：

- **基础时区配置**：各组件 Dockerfile 均已显式配置中国时区：`ENV TZ=Asia/Shanghai`。
- **AMD64 (x86_64) 构建**：`platforms: linux/amd64` -> 生成 `-amd64` 后缀镜像。
- **ARM64 (鲲鹏/信创) 构建**：`platforms: linux/arm64` -> 生成 `-arm64` 后缀镜像。
- **多架构 Manifest 聚合**：使用 `docker buildx imagetools create` 将以上两个单架构镜像聚合成一个不带架构后缀的多架构 Manifest Tag（例如 `alertmanager-v0.32.1`）。

---

## 5. 迭代命令

```bash
git switch prometheus && \
  git merge main --ff-only && \
  git push origin prometheus && \
  git switch main
```

```powershell
git switch prometheus ;`
  git merge main --ff-only ;`
  git push origin prometheus ;`
  git switch main
```
