# cert-manager

> 🚨 **【强制性规则】绝对禁止直接在触发分支上发起任何提交或修改！**  
> 所有配置变更、镜像版本升级必须且只能在 `main` 分支完成。触发分支仅作为 CI/CD 自动构建的专用触发分支。

---

## 🚫 严禁事项与操作铁律

1. **禁止直接 Commit**：不得擅自在构建分支修改 Dockerfile、README 或工作流。
2. **禁止产生脏 Merge 提交**：若出现 `refusing to merge unrelated histories` 报错，**严禁**使用常规 `git merge` 或乱加参数强行合并，必须统一使用 `git reset --hard main` 强制对齐主干历史！
3. **保持提交历史纯粹**：触发分支的 HEAD 必须镜像级对齐 `main` 分支。

---

## Github 地址

- cert-manager 上游项目：https://github.com/cert-manager/cert-manager
- alidns-webhook：https://github.com/pragkent/alidns-webhook
- kubernetes-reflector：https://github.com/emberstack/kubernetes-reflector

## 🔄 标准迭代与强制对齐命令

```bash
git switch cert-manager && \
  git reset --hard main && \
  git push origin cert-manager --force && \
  git switch main
```

```powershell
git switch cert-manager ;`
  git reset --hard main ;`
  git push origin cert-manager --force ;`
  git switch main
```

## 📌 概述与镜像构建说明

本目录用于同步并重新打包 cert-manager 相关镜像，基于上游镜像增加维护者标签和 `Asia/Shanghai` 时区配置。

GitHub Actions 工作流位于 `.github/workflows/cert-manager.yml`，推送 `cert-manager` 分支时触发构建。当前 cert-manager 版本为 `v1.19.3`，alidns-webhook 版本为 `0.1.0`，kubernetes-reflector 版本为 `9.1.45`。

主要镜像标签：

- `registry.cn-qingdao.aliyuncs.com/wod/cert-manager:controller-v1.19.3`
- `registry.cn-qingdao.aliyuncs.com/wod/cert-manager:webhook-v1.19.3`
- `registry.cn-qingdao.aliyuncs.com/wod/cert-manager:cainjector-v1.19.3`
- `registry.cn-qingdao.aliyuncs.com/wod/cert-manager:startupapicheck-v1.19.3`
- `registry.cn-qingdao.aliyuncs.com/wod/cert-manager:acmesolver-v1.19.3`
- `registry.cn-qingdao.aliyuncs.com/wod/cert-manager:alidns-webhook-0.1.0`
- `registry.cn-qingdao.aliyuncs.com/wod/cert-manager:reflector-9.1.45`

cert-manager 组件和 reflector 支持 `linux/amd64` 与 `linux/arm64`，alidns-webhook 当前仅构建 `linux/amd64`。
