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

## 🔄 标准迭代与强制对齐命令

```bash
git switch sub2api && \
  git reset --hard main && \
  git push origin sub2api --force && \
  git switch main
```

```powershell
git switch sub2api ;`
  git reset --hard main ;`
  git push origin sub2api --force ;`
  git switch main
```

## 📌 概述与镜像构建说明

本目录用于构建 Sub2API 镜像，基于上游 `weishaw/sub2api` 镜像补充维护者、版本标签和 `Asia/Shanghai` 时区配置。

GitHub Actions 工作流位于 `.github/workflows/sub2api.yml`，推送 `sub2api` 分支或手动触发工作流时执行构建。当前构建版本为 `0.1.175`，会构建 `linux/amd64` 和 `linux/arm64` 镜像，并推送到：

- `registry.cn-qingdao.aliyuncs.com/wod/sub2api:0.1.175`
- `registry.cn-qingdao.aliyuncs.com/wod/sub2api:0.1.175-amd64`
- `registry.cn-qingdao.aliyuncs.com/wod/sub2api:0.1.175-arm64`

其中不带架构后缀的版本标签为多平台镜像，可按运行环境自动选择架构。
