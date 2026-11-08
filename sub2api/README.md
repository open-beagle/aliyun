# Sub2API

> 🚨 **【强制性规则】绝对禁止直接在触发分支上发起任何提交或修改！**  
> 所有配置变更、镜像版本升级必须且只能在 `main` 分支完成。触发分支仅作为 CI/CD 自动构建的专用触发分支。

---

## 🚫 严禁事项与操作铁律

1. **禁止直接 Commit**：不得擅自在构建分支修改 Dockerfile、README 或工作流。
2. **禁止产生脏 Merge 提交**：若出现 `refusing to merge unrelated histories` 报错，**严禁**使用常规 `git merge` 或乱加参数强行合并，必须统一使用 `git reset --hard main` 强制对齐主干历史！
3. **保持提交历史纯粹**：触发分支的 HEAD 必须镜像级对齐 `main` 分支。

---

## Github 地址

- 上游项目：https://github.com/Wei-Shaw/sub2api
- 官方镜像：https://hub.docker.com/r/weishaw/sub2api

## 🔄 标准迭代与强制对齐命令

### Bash

```bash
git switch sub2api && \
  git reset --hard main && \
  git push origin sub2api --force && \
  git switch main
```

### PowerShell

```powershell
git switch sub2api ;`
  git reset --hard main ;`
  git push origin sub2api --force ;`
  git switch main
```

## 📌 概述与镜像构建说明

本目录用于构建 Sub2API 镜像。当前打包版本为 `0.2.20-fix`，基于上游官方发布版本 `v0.2.20`。本目录是镜像打包入口，不保存完整上游源码（本地上游检出目录位于 `.tmp/sub2api`）。

镜像内应用了 `grok-scheduler-tier.patch`，修复媒体调度的账号精简缓存丢失 Grok 套餐信息、导致 SuperGrok Plus 被误判为免费账号的问题。精简缓存只保存解析后的套餐，令牌套餐优先于旧凭据；不复制访问令牌或刷新令牌，不启用账号强制放行。

GitHub Actions 工作流位于 [`.github/workflows/sub2api.yml`](../.github/workflows/sub2api.yml)，推送 `sub2api` 分支或手动触发工作流时执行构建。当前构建版本为 `0.2.20-fix`。构建过程会自动拉取官方 `v0.2.20` 源码、应用补丁、编译前端及后端，并在原官方 `weishaw/sub2api:0.2.20` 基础运行环境中完成程序替换。构建支持 `linux/amd64` 和 `linux/arm64`，并推送到：

- `registry.cn-qingdao.aliyuncs.com/wod/sub2api:0.2.20-fix`

其中不带架构后缀的版本标签为多平台镜像，可按运行环境自动选择架构。构建完成后，工作流会自动连接 `k8s.verdantflare.ai` Kubernetes 集群，通过 `kubectl set image` 滚动更新 `verdantflare-team` 命名空间下的 `deployment/sub2api` 服务并等待就绪。

## 🧪 补丁验证与回归测试

当上游发布新版本时，基于本地上游代码目录 `.tmp/sub2api` 按以下三步完成升级与补丁核验：

### 1. 拉取更新本地代码

拉取上游最新标签并检出最新发布的版本（例如 `v0.2.20`）：

```powershell
git -C .tmp/sub2api fetch --tags origin --prune
git -C .tmp/sub2api tag --sort=-v:refname | Select-Object -First 5
git -C .tmp/sub2api checkout -f v0.2.20
```

### 2. 检查补丁是否合适并执行单元回归测试

检查上游 `backend/internal/repository/scheduler_cache.go` 中的 `buildSchedulerMetadataAccount` / `filterSchedulerCredentials` 是否已原生保留 Grok 套餐信息（`subscription_tier`）：

- **若上游已覆盖（补丁不再需要）**：删除 `sub2api/grok-scheduler-tier.patch` 与 `sub2api/grok_scheduler_tier_test.go`，移除 `.github/workflows/sub2api.yml` 中的 `Apply release patch` 步骤，直接基于上游版本构建。
- **若上游未覆盖（补丁仍合适，需保留）**：在 `.tmp/sub2api` 应用补丁并运行 `grok_scheduler_tier_test.go` 单元回归测试（该检查不依赖容器，覆盖付费识别、免费降级、无令牌回退、损坏令牌回退、未知套餐及其它平台兼容性，同时断言缓存不泄露访问令牌/刷新令牌且不修改完整账号；测试源码仅用于验证，不进入最终运行镜像）：

```powershell
git -C .tmp/sub2api apply ../../sub2api/grok-scheduler-tier.patch
Copy-Item sub2api/grok_scheduler_tier_test.go .tmp/sub2api/backend/internal/repository/grok_scheduler_tier_test.go -Force
Push-Location .tmp/sub2api/backend
go test -tags unit ./internal/repository -run TestGrokSchedulerTierProjection -count=1
Pop-Location
Remove-Item .tmp/sub2api/backend/internal/repository/grok_scheduler_tier_test.go -Force
git -C .tmp/sub2api checkout -- backend/internal/repository/scheduler_cache.go
```

### 3. 触发流水线升级

同步更新 `.github/workflows/sub2api.yml`、`sub2api/dockerfile` 与 `sub2api/README.md` 中的版本号（如 `0.2.20-fix` / `v0.2.20`），在 `main` 分支提交并推送后，执行上文“标准迭代与强制对齐命令”强制对齐推送 `sub2api` 分支，触发 GitHub Actions 自动构建多架构镜像并滚动更新 `k8s.verdantflare.ai` 集群 `verdantflare-team` 命名空间下的 `deployment/sub2api`。
