# SigNoz

## Github 地址

- 上游项目：https://github.com/SigNoz/signoz
- ClickHouse Operator：https://github.com/Altinity/clickhouse-operator
- k8s-wait-for：https://github.com/groundnuty/k8s-wait-for

## 迭代命令

```bash
git switch signoz && \
  git merge main --ff-only && \
  git push origin signoz && \
  git switch main
```

```powershell
git switch signoz ;`
  git merge main --ff-only ;`
  git push origin signoz ;`
  git switch main
```

## 概述

本目录用于构建 SigNoz 相关镜像，基于上游 SigNoz、Altinity 和 k8s-wait-for 镜像增加 `Asia/Shanghai` 时区配置。

GitHub Actions 工作流位于 `.github/workflows/signoz.yml`，推送 `signoz` 分支时触发构建。当前主要版本为 SigNoz `v0.107.0`、OTel Collector `v0.129.12`、ZooKeeper `3.7.1`、Altinity `0.21.2`、k8s-wait-for `v2.0`，会推送到 Aliyun 和 GHCR。

主要镜像标签：

- `registry.cn-qingdao.aliyuncs.com/wod/signoz:v0.107.0`
- `registry.cn-qingdao.aliyuncs.com/wod/signoz:otel-collector-v0.129.12`
- `registry.cn-qingdao.aliyuncs.com/wod/signoz:schema-migrator-v0.129.12`
- `registry.cn-qingdao.aliyuncs.com/wod/signoz:zookeeper-3.7.1`
- `registry.cn-qingdao.aliyuncs.com/wod/altinity:clickhouse-operator-0.21.2`
- `registry.cn-qingdao.aliyuncs.com/wod/altinity:metrics-exporter-0.21.2`
- `registry.cn-qingdao.aliyuncs.com/wod/signoz:k8s-wait-for-v2.0`

对应 GHCR 标签使用相同镜像名和 tag，仓库前缀为 `ghcr.io/open-beagle/`。其中 SigNoz、OTel Collector、schema-migrator、ZooKeeper 支持 `linux/amd64` 和 `linux/arm64`，Altinity 与 k8s-wait-for 镜像当前仅构建 `linux/amd64`。
