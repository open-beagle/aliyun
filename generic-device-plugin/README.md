# Generic Device Plugin

## Github 地址

- 上游项目：https://github.com/squat/generic-device-plugin

## 迭代命令

```bash
git switch generic-device-plugin && \
  git merge main --ff-only && \
  git push origin generic-device-plugin && \
  git switch main
```

```powershell
git switch generic-device-plugin ;`
  git merge main --ff-only ;`
  git push origin generic-device-plugin ;`
  git switch main
```

## 概述

本目录用于构建 Generic Device Plugin 镜像，基于上游 `squat/generic-device-plugin` 镜像补充维护者、版本标签和 `Asia/Shanghai` 时区配置。

GitHub Actions 工作流位于 `.github/workflows/generic-device-plugin.yml`，推送 `generic-device-plugin` 分支或手动触发时构建。当前构建版本为 `0.2.0`，会构建 `linux/amd64` 和 `linux/arm64` 镜像，并推送到：

- `registry.cn-qingdao.aliyuncs.com/wod/generic-device-plugin:0.2.0`
- `registry.cn-qingdao.aliyuncs.com/wod/generic-device-plugin:0.2.0-amd64`
- `registry.cn-qingdao.aliyuncs.com/wod/generic-device-plugin:0.2.0-arm64`

其中不带架构后缀的版本标签为多平台镜像，可按运行环境自动选择架构。
