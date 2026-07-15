# Sub2API

## Github 地址

- 上游项目：https://github.com/Wei-Shaw/sub2api

## 迭代命令

```bash
git switch sub2api && \
  git merge main --ff-only && \
  git push origin sub2api && \
  git switch main
```

```powershell
git switch sub2api ;`
  git merge main --ff-only ;`
  git push origin sub2api ;`
  git switch main
```

## 概述

本目录用于构建 Sub2API 镜像，基于上游 `weishaw/sub2api` 镜像补充维护者、版本标签和 `Asia/Shanghai` 时区配置。

GitHub Actions 工作流位于 `.github/workflows/sub2api.yml`，推送 `sub2api` 分支或手动触发工作流时执行构建。当前构建版本为 `0.1.156`，会构建 `linux/amd64` 和 `linux/arm64` 镜像，并推送到：

- `registry.cn-qingdao.aliyuncs.com/wod/sub2api:0.1.156`
- `registry.cn-qingdao.aliyuncs.com/wod/sub2api:0.1.156-amd64`
- `registry.cn-qingdao.aliyuncs.com/wod/sub2api:0.1.156-arm64`

其中不带架构后缀的版本标签为多平台镜像，可按运行环境自动选择架构。
