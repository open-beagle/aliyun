# Node

> 🚨 **【强制性规则】绝对禁止直接在触发分支上发起任何提交或修改！**  
> 所有配置变更、镜像版本升级必须且只能在 `main` 分支完成。触发分支仅作为 CI/CD 自动构建的专用触发分支。

---

## 🚫 严禁事项与操作铁律

1. **禁止直接 Commit**：不得擅自在构建分支修改 Dockerfile、README 或工作流。
2. **禁止产生脏 Merge 提交**：若出现 `refusing to merge unrelated histories` 报错，**严禁**使用常规 `git merge` 或乱加参数强行合并，必须统一使用 `git reset --hard main` 强制对齐主干历史！
3. **保持提交历史纯粹**：触发分支的 HEAD 必须镜像级对齐 `main` 分支。

---

## 上游镜像

- Docker Hub：https://hub.docker.com/_/node

## 特性说明

- **国内镜像源加速**：已默认配置 `pnpm` 的 registry 为国内镜像源 `https://registry.npmmirror.com`。
- **预装 pnpm**：所有镜像均预装了对应兼容版本的 `pnpm`：
  - Node 22 ~ Node 26：预装 `pnpm` 最新版 (`pnpm@latest`)
  - Node 18 ~ Node 20：预装 `pnpm@9` (pnpm 10+ 需要 Node >= 22.13 的内置 `node:sqlite` 模块)
  - Node 16：预装 `pnpm@8`
  - Node 14：预装 `pnpm@7`
  - Node 12：预装 `pnpm@6`
- **Debian 镜像**：基于上游 `node` 镜像打包，预装 `pnpm`。
- **Alpine 镜像**：基于上游 `node` 镜像，替换 Alpine 镜像源为阿里云镜像，增加 `Asia/Shanghai` 时区配置，配置 `beagle-ca.crt` 证书，并预装 `pnpm`。

## Node 26

### 🔄 标准迭代与强制对齐命令

```bash
git switch node-26 && \
  git reset --hard main && \
  git push origin node-26 --force && \
  git switch main
```

```powershell
git switch node-26 ;`
  git reset --hard main ;`
  git push origin node-26 --force ;`
  git switch main
```

### 📌 概述与镜像构建说明

- Debian 镜像直接基于上游 `node` 镜像打包。
- Alpine 镜像基于上游 `node` 镜像，替换了 Alpine 镜像源为阿里云镜像，增加了 `Asia/Shanghai` 时区配置，并配置了 `beagle-ca.crt` 证书。

GitHub Actions 工作流位于 `.github/workflows/node-26.yml`，推送 `node-26` 分支时触发构建。当前构建版本为 `26.4.0`，会构建 `linux/amd64` 和 `linux/arm64` 镜像，并推送到：

- `registry.cn-qingdao.aliyuncs.com/wod/node:26.4.0`
- `registry.cn-qingdao.aliyuncs.com/wod/node:26`
- `registry.cn-qingdao.aliyuncs.com/wod/node:26.4.0-amd64`
- `registry.cn-qingdao.aliyuncs.com/wod/node:26.4.0-arm64`
- `registry.cn-qingdao.aliyuncs.com/wod/node:26.4.0-alpine`
- `registry.cn-qingdao.aliyuncs.com/wod/node:26-alpine`
- `registry.cn-qingdao.aliyuncs.com/wod/node:26.4.0-alpine-amd64`
- `registry.cn-qingdao.aliyuncs.com/wod/node:26.4.0-alpine-arm64`

## Node 24

### 🔄 标准迭代与强制对齐命令

```bash
git switch node-24 && \
  git reset --hard main && \
  git push origin node-24 --force && \
  git switch main
```

```powershell
git switch node-24 ;`
  git reset --hard main ;`
  git push origin node-24 --force ;`
  git switch main
```

### 📌 概述与镜像构建说明

- Debian 镜像直接基于上游 `node` 镜像打包。
- Alpine 镜像基于上游 `node` 镜像，替换了 Alpine 镜像源为阿里云镜像，增加了 `Asia/Shanghai` 时区配置，并配置了 `beagle-ca.crt` 证书。

GitHub Actions 工作流位于 `.github/workflows/node-24.yml`，推送 `node-24` 分支时触发构建。当前构建版本为 `24.18.0`，会构建 `linux/amd64` 和 `linux/arm64` 镜像，并推送到：

- `registry.cn-qingdao.aliyuncs.com/wod/node:24.18.0`
- `registry.cn-qingdao.aliyuncs.com/wod/node:24`
- `registry.cn-qingdao.aliyuncs.com/wod/node:24.18.0-amd64`
- `registry.cn-qingdao.aliyuncs.com/wod/node:24.18.0-arm64`
- `registry.cn-qingdao.aliyuncs.com/wod/node:24.18.0-alpine`
- `registry.cn-qingdao.aliyuncs.com/wod/node:24-alpine`
- `registry.cn-qingdao.aliyuncs.com/wod/node:24.18.0-alpine-amd64`
- `registry.cn-qingdao.aliyuncs.com/wod/node:24.18.0-alpine-arm64`

## Node 22

### 🔄 标准迭代与强制对齐命令

```bash
git switch node-22 && \
  git reset --hard main && \
  git push origin node-22 --force && \
  git switch main
```

```powershell
git switch node-22 ;`
  git reset --hard main ;`
  git push origin node-22 --force ;`
  git switch main
```

### 📌 概述与镜像构建说明

- Debian 镜像直接基于上游 `node` 镜像打包。
- Alpine 镜像基于上游 `node` 镜像，替换了 Alpine 镜像源为阿里云镜像，增加了 `Asia/Shanghai` 时区配置，并配置了 `beagle-ca.crt` 证书。

GitHub Actions 工作流位于 `.github/workflows/node-22.yml`，推送 `node-22` 分支时触发构建。当前构建版本为 `22.22.3`，会构建 `linux/amd64` 和 `linux/arm64` 镜像，并推送到：

- `registry.cn-qingdao.aliyuncs.com/wod/node:22.22.3`
- `registry.cn-qingdao.aliyuncs.com/wod/node:22`
- `registry.cn-qingdao.aliyuncs.com/wod/node:22.22.3-amd64`
- `registry.cn-qingdao.aliyuncs.com/wod/node:22.22.3-arm64`
- `registry.cn-qingdao.aliyuncs.com/wod/node:22.22.3-alpine`
- `registry.cn-qingdao.aliyuncs.com/wod/node:22-alpine`
- `registry.cn-qingdao.aliyuncs.com/wod/node:22.22.3-alpine-amd64`
- `registry.cn-qingdao.aliyuncs.com/wod/node:22.22.3-alpine-arm64`

## Node 20

### 🔄 标准迭代与强制对齐命令

```bash
git switch node-20 && \
  git reset --hard main && \
  git push origin node-20 --force && \
  git switch main
```

```powershell
git switch node-20 ;`
  git reset --hard main ;`
  git push origin node-20 --force ;`
  git switch main
```

### 📌 概述与镜像构建说明

- Debian 镜像直接基于上游 `node` 镜像打包。
- Alpine 镜像基于上游 `node` 镜像，替换了 Alpine 镜像源为阿里云镜像，增加了 `Asia/Shanghai` 时区配置，并配置了 `beagle-ca.crt` 证书。

GitHub Actions 工作流位于 `.github/workflows/node-20.yml`，推送 `node-20` 分支时触发构建。当前构建版本为 `20.20.2`，会构建 `linux/amd64` 和 `linux/arm64` 镜像，并推送到：

- `registry.cn-qingdao.aliyuncs.com/wod/node:20.20.2`
- `registry.cn-qingdao.aliyuncs.com/wod/node:20`
- `registry.cn-qingdao.aliyuncs.com/wod/node:20.20.2-amd64`
- `registry.cn-qingdao.aliyuncs.com/wod/node:20.20.2-arm64`
- `registry.cn-qingdao.aliyuncs.com/wod/node:20.20.2-alpine`
- `registry.cn-qingdao.aliyuncs.com/wod/node:20-alpine`
- `registry.cn-qingdao.aliyuncs.com/wod/node:20.20.2-alpine-amd64`
- `registry.cn-qingdao.aliyuncs.com/wod/node:20.20.2-alpine-arm64`

## Node 18

### 🔄 标准迭代与强制对齐命令

```bash
git switch node-18 && \
  git reset --hard main && \
  git push origin node-18 --force && \
  git switch main
```

```powershell
git switch node-18 ;`
  git reset --hard main ;`
  git push origin node-18 --force ;`
  git switch main
```

### 📌 概述与镜像构建说明

- Debian 镜像直接基于上游 `node` 镜像打包。
- Alpine 镜像基于上游 `node` 镜像，替换了 Alpine 镜像源为阿里云镜像，增加了 `Asia/Shanghai` 时区配置，并配置了 `beagle-ca.crt` 证书。

GitHub Actions 工作流位于 `.github/workflows/node-18.yml`，推送 `node-18` 分支时触发构建。当前构建版本为 `18.20.8`，会构建 `linux/amd64` 和 `linux/arm64` 镜像，并推送到：

- `registry.cn-qingdao.aliyuncs.com/wod/node:18.20.8`
- `registry.cn-qingdao.aliyuncs.com/wod/node:18`
- `registry.cn-qingdao.aliyuncs.com/wod/node:18.20.8-amd64`
- `registry.cn-qingdao.aliyuncs.com/wod/node:18.20.8-arm64`
- `registry.cn-qingdao.aliyuncs.com/wod/node:18.20.8-alpine`
- `registry.cn-qingdao.aliyuncs.com/wod/node:18-alpine`
- `registry.cn-qingdao.aliyuncs.com/wod/node:18.20.8-alpine-amd64`
- `registry.cn-qingdao.aliyuncs.com/wod/node:18.20.8-alpine-arm64`

## Node 16

### 🔄 标准迭代与强制对齐命令

```bash
git switch node-16 && \
  git reset --hard main && \
  git push origin node-16 --force && \
  git switch main
```

```powershell
git switch node-16 ;`
  git reset --hard main ;`
  git push origin node-16 --force ;`
  git switch main
```

### 📌 概述与镜像构建说明

- Debian 镜像直接基于上游 `node` 镜像打包。
- Alpine 镜像基于上游 `node` 镜像，替换了 Alpine 镜像源为阿里云镜像，增加了 `Asia/Shanghai` 时区配置，并配置了 `beagle-ca.crt` 证书。

GitHub Actions 工作流位于 `.github/workflows/node-16.yml`，推送 `node-16` 分支时触发构建。当前构建版本为 `16.20.2`，会构建 `linux/amd64` 和 `linux/arm64` 镜像，并推送到：

- `registry.cn-qingdao.aliyuncs.com/wod/node:16.20.2`
- `registry.cn-qingdao.aliyuncs.com/wod/node:16`
- `registry.cn-qingdao.aliyuncs.com/wod/node:16.20.2-amd64`
- `registry.cn-qingdao.aliyuncs.com/wod/node:16.20.2-arm64`
- `registry.cn-qingdao.aliyuncs.com/wod/node:16.20.2-alpine`
- `registry.cn-qingdao.aliyuncs.com/wod/node:16-alpine`
- `registry.cn-qingdao.aliyuncs.com/wod/node:16.20.2-alpine-amd64`
- `registry.cn-qingdao.aliyuncs.com/wod/node:16.20.2-alpine-arm64`

## Node 14

### 🔄 标准迭代与强制对齐命令

```bash
git switch node-14 && \
  git reset --hard main && \
  git push origin node-14 --force && \
  git switch main
```

```powershell
git switch node-14 ;`
  git reset --hard main ;`
  git push origin node-14 --force ;`
  git switch main
```

### 📌 概述与镜像构建说明

- Debian 镜像直接基于上游 `node` 镜像打包。
- Alpine 镜像基于上游 `node` 镜像，替换了 Alpine 镜像源为阿里云镜像，增加了 `Asia/Shanghai` 时区配置，并配置了 `beagle-ca.crt` 证书。

GitHub Actions 工作流位于 `.github/workflows/node-14.yml`，推送 `node-14` 分支时触发构建。当前构建版本为 `14.21.3`，会构建 `linux/amd64` 和 `linux/arm64` 镜像，并推送到：

- `registry.cn-qingdao.aliyuncs.com/wod/node:14.21.3`
- `registry.cn-qingdao.aliyuncs.com/wod/node:14`
- `registry.cn-qingdao.aliyuncs.com/wod/node:14.21.3-amd64`
- `registry.cn-qingdao.aliyuncs.com/wod/node:14.21.3-arm64`
- `registry.cn-qingdao.aliyuncs.com/wod/node:14.21.3-alpine`
- `registry.cn-qingdao.aliyuncs.com/wod/node:14-alpine`
- `registry.cn-qingdao.aliyuncs.com/wod/node:14.21.3-alpine-amd64`
- `registry.cn-qingdao.aliyuncs.com/wod/node:14.21.3-alpine-arm64`

## Node 12

### 🔄 标准迭代与强制对齐命令

```bash
git switch node-12 && \
  git reset --hard main && \
  git push origin node-12 --force && \
  git switch main
```

```powershell
git switch node-12 ;`
  git reset --hard main ;`
  git push origin node-12 --force ;`
  git switch main
```

### 📌 概述与镜像构建说明

- Debian 镜像直接基于上游 `node` 镜像打包。
- Alpine 镜像基于上游 `node` 镜像，替换了 Alpine 镜像源为阿里云镜像，增加了 `Asia/Shanghai` 时区配置，并配置了 `beagle-ca.crt` 证书。

GitHub Actions 工作流位于 `.github/workflows/node-12.yml`，推送 `node-12` 分支时触发构建。当前构建版本为 `12.22.12`，会构建 `linux/amd64` 和 `linux/arm64` 镜像，并推送到：

- `registry.cn-qingdao.aliyuncs.com/wod/node:12.22.12`
- `registry.cn-qingdao.aliyuncs.com/wod/node:12`
- `registry.cn-qingdao.aliyuncs.com/wod/node:12.22.12-amd64`
- `registry.cn-qingdao.aliyuncs.com/wod/node:12.22.12-arm64`
- `registry.cn-qingdao.aliyuncs.com/wod/node:12.22.12-alpine`
- `registry.cn-qingdao.aliyuncs.com/wod/node:12-alpine`
- `registry.cn-qingdao.aliyuncs.com/wod/node:12.22.12-alpine-amd64`
- `registry.cn-qingdao.aliyuncs.com/wod/node:12.22.12-alpine-arm64`
