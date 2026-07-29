# SigNoz

> 🚨 **【强制性规则】绝对禁止直接在触发分支上发起任何提交或修改！**  
> 所有配置变更、镜像版本升级必须且只能在 `main` 分支完成。触发分支仅作为 CI/CD 自动构建的专用触发分支。

---

## 🚫 严禁事项与操作铁律

1. **禁止直接 Commit**：不得擅自在构建分支修改 Dockerfile、README 或工作流。
2. **禁止产生脏 Merge 提交**：若出现 `refusing to merge unrelated histories` 报错，**严禁**使用常规 `git merge` 或乱加参数强行合并，必须统一使用 `git reset --hard main` 强制对齐主干历史！
3. **保持提交历史纯粹**：触发分支的 HEAD 必须镜像级对齐 `main` 分支。

---

## Github 地址

- 上游项目：https://github.com/SigNoz/signoz
- ClickHouse Operator：https://github.com/Altinity/clickhouse-operator
- k8s-wait-for：https://github.com/groundnuty/k8s-wait-for

## 🔄 标准迭代与强制对齐命令

```bash
git switch signoz && \
  git reset --hard main && \
  git push origin signoz --force && \
  git switch main
```

```powershell
git switch signoz ;`
  git reset --hard main ;`
  git push origin signoz --force ;`
  git switch main
```

## 📌 概述与镜像构建说明

本目录用于构建 SigNoz 相关镜像，基于上游 SigNoz、Altinity 和 k8s-wait-for 镜像增加 `Asia/Shanghai` 时区配置。

GitHub Actions 工作流位于 `.github/workflows/signoz.yml`，推送 `signoz` 分支时触发构建。当前主要版本为 SigNoz `v0.107.0`、OTel Collector `v0.129.12`、ZooKeeper `3.7.1`、Altinity `0.21.2`、k8s-wait-for `v2.0`，会推送到 Aliyun 和 GHCR。

主要镜像标签：

- `registry.cn-qingdao.aliyuncs.com/wod/signoz:v0.107.0`
- `registry.cn-qingdao.aliyuncs.com/wod/signoz:otel-collector-v0.129.12`
- `registry.cn-qingdao.aliyuncs.com/wod/signoz:schema-migrator-v0.129.12`
- `registry.cn-qingdao.aliyuncs.com/wod/signoz:zookeeper-3.7.1`
- `registry.cn-qingdao.aliyuncs.com/wod/altinity:clickhouse-operator-0.21.2`
- `registry.cn-qingdao.aliyuncs.com/wod/altinity:metrics-exporter-0.21.2`
- `registry.cn-qingdao.aliyuncs.com/wod/signoz:k8s-wait-for-v2.0`

对应 GHCR 标签使用相同镜像名和 tag，仓库前缀为 `ghcr.io/open-beagle/`。其中 SigNoz、OTel Collector、schema-migrator、ZooKeeper 支持 `linux/amd64` 和 `linux/arm64`，Altinity 与 k8s-wait-for 镜像当前仅构建 `linux/amd64`。
