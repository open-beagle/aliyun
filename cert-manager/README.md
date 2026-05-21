# cert-manager

## Github 地址

- cert-manager 上游项目：https://github.com/cert-manager/cert-manager
- alidns-webhook：https://github.com/pragkent/alidns-webhook
- kubernetes-reflector：https://github.com/emberstack/kubernetes-reflector

## 迭代命令

```bash
git switch cert-manager && \
  git merge main --ff-only && \
  git push origin cert-manager && \
  git switch main
```

```powershell
git switch cert-manager ;`
  git merge main --ff-only ;`
  git push origin cert-manager ;`
  git switch main
```

## 概述

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
