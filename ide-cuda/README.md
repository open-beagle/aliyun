# Ide-cuda

## 迭代命令

### Bash

```bash
# ide-cuda 迭代
git switch ide-cuda && \
  git merge main --ff-only && \
  git push origin ide-cuda && \
  git switch main
```

### PowerShell

```powershell
# ide-cuda 迭代
git switch ide-cuda ;`
  git merge main --ff-only ;`
  git push origin ide-cuda ;`
  git switch main
```

## 概述

本目录用于构建 Ide-cuda 镜像，基于上游项目进行定制开发，主要集成了 Beagle 内部环境的配置（如加速源、CA 证书、时区等）。

推送到 `ide-cuda` 分支时，会触发相应的 GitHub Actions 工作流构建镜像并推送到阿里云容器镜像服务。

### 主要特性

- **中国镜像加速**：APT 源替换为 `mirrors.aliyun.com`，pip 源替换为阿里云 PyPI 镜像。
- **Codex CLI 支持**：预装 `bubblewrap`（沙箱隔离）和 `ripgrep`（代码搜索），满足 OpenAI Codex CLI 运行依赖。
- **VS Code Remote-SSH 优化**：
  - 预写 `fs.inotify.max_user_watches=524288` sysctl 配置，容器启动时自动尝试提升上限。
  - 预置 Machine-level `settings.json`，配置 `files.watcherExclude` 排除 `node_modules`、`.cache`、`vendor` 等高噪音目录。

