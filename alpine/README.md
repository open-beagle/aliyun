# Alpine

> 🚨 **【强制性规则】绝对禁止直接在触发分支上发起任何提交或修改！**  
> 所有配置变更、镜像版本升级必须且只能在 `main` 分支完成。触发分支仅作为 CI/CD 自动构建的专用触发分支。

---

## 🚫 严禁事项与操作铁律

1. **禁止直接 Commit**：不得擅自在构建分支修改 Dockerfile、README 或工作流。
2. **禁止产生脏 Merge 提交**：若出现 `refusing to merge unrelated histories` 报错，**严禁**使用常规 `git merge` 或乱加参数强行合并，必须统一使用 `git reset --hard main` 强制对齐主干历史！
3. **保持提交历史纯粹**：触发分支的 HEAD 必须镜像级对齐 `main` 分支。

---

## Github 地址

- 上游项目：https://alpinelinux.org/
- 上游镜像：https://hub.docker.com/_/alpine

## 🔄 标准迭代与强制对齐命令

### Bash

```bash
# alpine 迭代
git switch alpine && \
  git reset --hard main && \
  git push origin alpine --force && \
  git switch main
```

### PowerShell

```powershell
# alpine 迭代
git switch alpine ;`
  git reset --hard main ;`
  git push origin alpine --force ;`
  git switch main
```

## 📌 概述与镜像构建说明

本目录用于构建 Alpine 镜像，基于上游官方镜像进行定制开发，主要集成了：

- **包管理器加速**: 使用 `mirrors.aliyun.com` 替换默认源。
- **时区配置**: 安装 `tzdata` 并配置 `Asia/Shanghai` 时区。
- **常用工具**: 安装 `bash`、`ca-certificates`、`curl`、`iptables`、`iproute2` 等基础工具。
- **证书配置**: 导入 Beagle 内部 CA 证书（`beagle-ca.crt`）以信任内部服务。

GitHub Actions 工作流文件位于 `.github/workflows/alpine.yml`，推送到 `alpine` 分支时会触发构建并推送到阿里云容器镜像服务和 GitHub Container Registry（GHCR）。支持 `linux/amd64` 和 `linux/arm64` 多架构。

## 镜像

### Alpine 3.22

- **多架构 (AMD64/ARM64)**
  - `registry.cn-qingdao.aliyuncs.com/wod/alpine:3.22.5`
  - `registry.cn-qingdao.aliyuncs.com/wod/alpine:3.22`
  - `registry.cn-qingdao.aliyuncs.com/wod/alpine:3`
  - `ghcr.io/open-beagle/alpine:3.22.5`
  - `ghcr.io/open-beagle/alpine:3.22`
  - `ghcr.io/open-beagle/alpine:3`
- **AMD64**
  - `registry.cn-qingdao.aliyuncs.com/wod/alpine:3.22.5-amd64`
  - `registry.cn-qingdao.aliyuncs.com/wod/alpine:3.22-amd64`
  - `registry.cn-qingdao.aliyuncs.com/wod/alpine:3-amd64`
  - `ghcr.io/open-beagle/alpine:3.22.5-amd64`
  - `ghcr.io/open-beagle/alpine:3.22-amd64`
  - `ghcr.io/open-beagle/alpine:3-amd64`
- **ARM64**
  - `registry.cn-qingdao.aliyuncs.com/wod/alpine:3.22.5-arm64`
  - `registry.cn-qingdao.aliyuncs.com/wod/alpine:3.22-arm64`
  - `registry.cn-qingdao.aliyuncs.com/wod/alpine:3-arm64`
  - `ghcr.io/open-beagle/alpine:3.22.5-arm64`
  - `ghcr.io/open-beagle/alpine:3.22-arm64`
  - `ghcr.io/open-beagle/alpine:3-arm64`

## 构建

### 镜像构建

```bash
docker build \
  --build-arg BASE=alpine:3.22.5 \
  --build-arg AUTHOR=open-beagle \
  --build-arg VERSION=3.22.5 \
  -t registry.cn-qingdao.aliyuncs.com/wod/alpine:3.22.5 \
  -t ghcr.io/open-beagle/alpine:3.22.5 \
  -f alpine/alpine.dockerfile .
```

## 推送

```bash
docker push registry.cn-qingdao.aliyuncs.com/wod/alpine:3.22.5
docker push registry.cn-qingdao.aliyuncs.com/wod/alpine:3.22.5-amd64
docker push registry.cn-qingdao.aliyuncs.com/wod/alpine:3.22.5-arm64
docker push ghcr.io/open-beagle/alpine:3.22.5
docker push ghcr.io/open-beagle/alpine:3.22.5-amd64
docker push ghcr.io/open-beagle/alpine:3.22.5-arm64
```

## 运行

```bash
docker run --rm -it \
  -v $(pwd):/workspace \
  registry.cn-qingdao.aliyuncs.com/wod/alpine:3.22.5 \
  bash
```

或从 GHCR 拉取：

```bash
docker run --rm -it \
  -v $(pwd):/workspace \
  ghcr.io/open-beagle/alpine:3.22.5 \
  bash
```
