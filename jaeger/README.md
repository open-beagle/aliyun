# Jaeger

## Github 地址

- Jaeger 上游项目：https://github.com/jaegertracing/jaeger
- OpenTelemetry Collector：https://github.com/open-telemetry/opentelemetry-collector-contrib

## 迭代命令

```bash
git switch jaeger && \
  git merge main --ff-only && \
  git push origin jaeger && \
  git switch main
```

```powershell
git switch jaeger ;`
  git merge main --ff-only ;`
  git push origin jaeger ;`
  git switch main
```

## 概述

本目录用于构建 Jaeger 和 OpenTelemetry Collector Contrib 镜像，基于上游镜像增加 `Asia/Shanghai` 时区配置。

GitHub Actions 工作流位于 `.github/workflows/jaeger.yml`，推送 `jaeger` 分支时触发构建。当前 Jaeger 版本为 `2.14.1`，OpenTelemetry Collector Contrib 版本为 `0.143.1`，会分别构建 `linux/amd64` 和 `linux/arm64` 镜像，并推送到：

- `registry.cn-qingdao.aliyuncs.com/wod/jaeger:2.14.1`
- `registry.cn-qingdao.aliyuncs.com/wod/opentelemetry-collector-contrib:0.143.1`
- `ghcr.io/open-beagle/jaeger:2.14.1`
- `ghcr.io/open-beagle/opentelemetry-collector-contrib:0.143.1`

工作流同时会为两个架构创建统一的多架构 manifest，运行时可直接使用不带架构后缀的版本标签。
