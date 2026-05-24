# Prometheus 组件多架构镜像构建与同步

本目录包含了用于在 2026 年同步和打包 **Prometheus 生态核心组件** 至阿里云私有镜像服务的 Docker 编译定义和多架构流水线。

---

## 1. 组件与私有 Tags 设计（K8s v1.32.10 兼容）

为了完美兼容目标 Kubernetes **`v1.32.10`** 平台，本流水线对核心组件的版本进行了精确对齐：

| 组件名称               | 上游基础拉取源                                                  | 私有库推送 Tag                                                               | 兼容说明                                                                               |
| :--------------------- | :-------------------------------------------------------------- | :--------------------------------------------------------------------------- | :------------------------------------------------------------------------------------- |
| **Alertmanager**       | `quay.io/prometheus/alertmanager:v0.32.1`                       | `registry.cn-qingdao.aliyuncs.com/wod/prometheus:alertmanager-v0.32.1`       | 中心端与边缘端的高级告警收拢                                                           |
| **Node Exporter**      | `quay.io/prometheus/node-exporter:v1.8.1`                       | `registry.cn-qingdao.aliyuncs.com/wod/prometheus:node-exporter-v1.8.1`       | 宿主机底层硬件、CPU/内存/磁盘物理指标暴露                                              |
| **Kube State Metrics** | `registry.k8s.io/kube-state-metrics/kube-state-metrics:v2.14.0` | `registry.cn-qingdao.aliyuncs.com/wod/prometheus:kube-state-metrics-v2.14.0` | **深度适配 K8s v1.32.x API 组**，防范旧版（v2.12及以下）在 1.32 API 废弃阶段的解析故障 |

---

## 2. 编译与时区配置

所有组件 Dockerfile 均已包装了官方原始容器，显式配置了中国标准时区：`ENV TZ=Asia/Shanghai`。
CI/CD 流水线自动完成 `linux/amd64` 和 `linux/arm64` 的多架构联合构建。
