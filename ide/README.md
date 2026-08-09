# IDE

> 🚨 **【强制性规则】绝对禁止直接在触发分支上发起任何提交或修改！**  
> 所有配置变更、镜像版本升级必须且只能在 `main` 分支完成。触发分支仅作为 CI/CD 自动构建的专用触发分支。

---

## 🚫 严禁事项与操作铁律

1. **禁止直接 Commit**：不得擅自在构建分支修改 Dockerfile、README 或工作流。
2. **禁止产生脏 Merge 提交**：若出现 `refusing to merge unrelated histories` 报错，**严禁**使用常规 `git merge` 或乱加参数强行合并，必须统一使用 `git reset --hard main` 强制对齐主干历史！
3. **保持提交历史纯粹**：触发分支的 HEAD 必须镜像级对齐 `main` 分支。

---

## Github 地址

- Debian 上游项目：https://www.debian.org/
- Debian 上游镜像：https://hub.docker.com/_/debian
- CUDA 上游项目：https://developer.nvidia.com/cuda-toolkit
- CUDA 上游镜像：https://hub.docker.com/r/nvidia/cuda

## 🔄 标准迭代与强制对齐命令

### Bash

```bash
# 通用 IDE 镜像
git switch ide && \
  git reset --hard main && \
  git push --force-with-lease origin ide && \
  git switch main

# CUDA IDE 镜像
git switch ide-cuda && \
  git reset --hard main && \
  git push --force-with-lease origin ide-cuda && \
  git switch main
```

### PowerShell

```powershell
# 通用 IDE 镜像
git switch ide ;`
  git reset --hard main ;`
  git push --force-with-lease origin ide ;`
  git switch main

# CUDA IDE 镜像
git switch ide-cuda ;`
  git reset --hard main ;`
  git push --force-with-lease origin ide-cuda ;`
  git switch main
```

## 📌 概述与镜像构建说明

本目录使用同一个 Dockerfile 构建通用 IDE 和 CUDA IDE 镜像，两者仅通过 `BASE` 构建参数选择不同的基础镜像。镜像预置以下开发环境：

- **Codex CLI 依赖**：`bubblewrap` 和 `ripgrep`。
- **开发工具链**：Python 3、`pip`、`venv`、`build-essential`、`pkg-config`、Git 与常用命令行工具；PyPI 默认使用阿里云镜像。
- **桌面应用构建与交叉编译**：`libgtk-3-dev`、`libwebkit2gtk-4.1-dev`、`libsoup-3.0-dev`（Wails/GTK3/WebKit2GTK/libsoup3 原生桌面构建依赖）及 `gcc-mingw-w64-x86-64`、`g++-mingw-w64-x86-64`（MinGW-w64 Windows 64位交叉编译工具链，默认启用 posix 线程模型）。
- **服务与容器工具**：SSH 服务端与客户端、Podman、crun、fuse-overlayfs、PostgreSQL 客户端与 Redis 工具。
- **网络诊断工具**：`dnsutils`、`net-tools`、`telnet`、`inotify-tools`、`iptables` 与 `iproute2`。
- **无头浏览器与 Playwright 支持**：Chromium、Noto CJK 字体、Python Playwright 及全局 Chromium 驱动（`PLAYWRIGHT_BROWSERS_PATH=/ms-playwright`），开箱即用支持前端自动化与截图。

镜像会以 UID/GID 1000 创建或复用 `code` 用户，并配置免密 `sudo`、rootless Podman 存储目录和 CUDA 库路径。

GitHub Actions 工作流位于 `.github/workflows/ide.yml` 和 `.github/workflows/ide-cuda.yml`。推送到 `ide` 分支会构建 `linux/amd64` 和 `linux/arm64` 通用 IDE 镜像；推送到 `ide-cuda` 分支会构建 AMD64 CUDA IDE 镜像。两者使用同一个 `ide/dockerfile`。

## 镜像

### IDE 13 (Debian Trixie)

- **多架构 (AMD64/ARM64)**
  - `registry.cn-qingdao.aliyuncs.com/wod/ide:13`
  - `registry.cn-qingdao.aliyuncs.com/wod/ide:trixie`
- **AMD64**
  - `registry.cn-qingdao.aliyuncs.com/wod/ide:13-amd64`
  - `registry.cn-qingdao.aliyuncs.com/wod/ide:trixie-amd64`
- **ARM64**
  - `registry.cn-qingdao.aliyuncs.com/wod/ide:13-arm64`
  - `registry.cn-qingdao.aliyuncs.com/wod/ide:trixie-arm64`

### CUDA 12.6.3 (Ubuntu 24.04)

- **AMD64**
  - `registry.cn-qingdao.aliyuncs.com/wod/ide:cuda12.6.3-devel-ubuntu24.04`

## 构建

```bash
# 通用 IDE 镜像
docker build \
  --build-arg BASE=debian:trixie \
  --build-arg AUTHOR=open-beagle \
  --build-arg VERSION=13 \
  -t registry.cn-qingdao.aliyuncs.com/wod/ide:13 \
  -f ide/dockerfile .

# CUDA IDE 镜像
docker build \
  --build-arg BASE=nvidia/cuda:12.6.3-devel-ubuntu24.04 \
  --build-arg AUTHOR=open-beagle \
  --build-arg VERSION=12.6.3-devel-ubuntu24.04 \
  -t registry.cn-qingdao.aliyuncs.com/wod/ide:cuda12.6.3-devel-ubuntu24.04 \
  -f ide/dockerfile .
```

## 推送

```bash
docker push registry.cn-qingdao.aliyuncs.com/wod/ide:13
docker push registry.cn-qingdao.aliyuncs.com/wod/ide:13-amd64
docker push registry.cn-qingdao.aliyuncs.com/wod/ide:13-arm64
docker push registry.cn-qingdao.aliyuncs.com/wod/ide:cuda12.6.3-devel-ubuntu24.04
```

## 运行

通用 IDE：

```bash
docker run --rm -it \
  -v $(pwd):/workspace \
  registry.cn-qingdao.aliyuncs.com/wod/ide:13 \
  bash
```

CUDA IDE 主机需要安装 NVIDIA Container Toolkit，才能将 GPU 暴露给容器：

```bash
docker run --rm -it --gpus all \
  -v $(pwd):/workspace \
  registry.cn-qingdao.aliyuncs.com/wod/ide:cuda12.6.3-devel-ubuntu24.04 \
  bash
```
