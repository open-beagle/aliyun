# Grafana 多架构镜像构建与同步

本目录包含了用于在 2026 年同步和打包 **Grafana** 可视化平台至阿里云私有镜像服务的 Docker 编译定义和多架构流水线。

---

## 1. 组件与私有 Tags 设计

- **上游拉取源**：`grafana/grafana:11.6.14`
- **私有库推送 Tag**：`registry.cn-qingdao.aliyuncs.com/wod/grafana:11.6.14`

---

## 2. 迭代与编译定义

本目录下的 Dockerfile 通过对官方 Grafana 容器进行包装，显式配置了中国标准时区：`ENV TZ=Asia/Shanghai`。
CI/CD 自动完成多架构 `linux/amd64` 和 `linux/arm64` 的构建，并打包合并成统一的多架构 Manifest。
