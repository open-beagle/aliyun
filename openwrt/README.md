# OpenWRT ImageBuilder

> 🚨 **【强制性规则】绝对禁止直接在触发分支上发起任何提交或修改！**  
> 所有配置变更、镜像版本升级必须且只能在 `main` 分支完成。触发分支仅作为 CI/CD 自动构建的专用触发分支。

---

## 🚫 严禁事项与操作铁律

1. **禁止直接 Commit**：不得擅自在构建分支修改 Dockerfile、README 或工作流。
2. **禁止产生脏 Merge 提交**：若出现 `refusing to merge unrelated histories` 报错，**严禁**使用常规 `git merge` 或乱加参数强行合并，必须统一使用 `git reset --hard main` 强制对齐主干历史！
3. **保持提交历史纯粹**：触发分支的 HEAD 必须镜像级对齐 `main` 分支。

---

## Github 地址

- 上游项目：https://hub.docker.com/r/openwrt/imagebuilder

## 🔄 标准迭代与强制对齐命令

### 对于 v25 版本 (最新)

```bash
git switch openwrt-v25 && \
  git reset --hard main && \
  git push origin openwrt-v25 --force && \
  git switch main
```

```powershell
git switch openwrt-v25 ;`
  git reset --hard main ;`
  git push origin openwrt-v25 --force ;`
  git switch main
```

### 对于 v24 版本

```bash
git switch openwrt-v24 && \
  git reset --hard main && \
  git push origin openwrt-v24 --force && \
  git switch main
```

```powershell
git switch openwrt-v24 ;`
  git reset --hard main ;`
  git push origin openwrt-v24 --force ;`
  git switch main
```

## 📌 概述与镜像构建说明

本目录用于构建 OpenWRT ImageBuilder 镜像，基于上游 `openwrt/imagebuilder` 镜像。

GitHub Actions 工作流根据不同的版本有不同的配置文件：

- 对于 `v25`：工作流位于 `.github/workflows/openwrt-v25.yml`，推送 `openwrt-v25` 分支时触发构建。当前构建版本为 `v25.12.4`，会构建 `x86-64` 和 `rockchip-armv8` 镜像，并推送到：
  - `registry.cn-qingdao.aliyuncs.com/wod/openwrt-imagebuilder:x86-64-v25.12.4`
  - `registry.cn-qingdao.aliyuncs.com/wod/openwrt-imagebuilder:rockchip-armv8-v25.12.4`

- 对于 `v24`：工作流位于 `.github/workflows/openwrt-v24.yml`，推送 `openwrt-v24` 分支时触发构建。当前构建版本为 `v24.10.7`，会构建 `x86-64` 和 `rockchip-armv8` 镜像，并推送到：
  - `registry.cn-qingdao.aliyuncs.com/wod/openwrt-imagebuilder:x86-64-v24.10.7`
  - `registry.cn-qingdao.aliyuncs.com/wod/openwrt-imagebuilder:rockchip-armv8-v24.10.7`
