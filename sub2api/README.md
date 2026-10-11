# Sub2API 镜像

## 1. 版本与补丁

当前打包版本为 `0.2.16`，基于上游 `0.2.15` 的固定提交 `f2669c8cf62555cd92389b3f55920e9e6e7c6ff2`。本目录是镜像打包入口，不保存完整上游源码。

`grok-scheduler-tier.patch` 修复媒体调度的账号精简缓存丢失 Grok 套餐信息，导致 SuperGrok Plus 被误判为免费账号的问题。精简缓存只保存解析后的套餐，令牌套餐优先于旧凭据；不复制访问令牌或刷新令牌，不启用账号强制放行。

Actions 获取固定上游源码、应用补丁、构建前端及后端，并在原 `weishaw/sub2api:0.2.15` 运行环境中替换程序。发布目标为 `registry.cn-qingdao.aliyuncs.com/wod/sub2api:0.2.16`，支持 amd64/arm64，不覆盖既有标签。

## 2. 开发与交付

本目录按 [VerdantFlare Actions 指南](https://github.com/verdantflarehub/verdantflare-design/blob/dev/docs/GithubAction.md)执行。开发在现有工作区的 `dev` 完成，检查通过后推送 `dev`，`release` 仅快进触发构建，返回 `dev`；线上验证后同步 `main`。旧 `sub2api` 触发分支不再用于本目录发布，不执行 reset 或强推。

工作流 [.github/workflows/sub2api.yml](../.github/workflows/sub2api.yml)只负责编译与镜像推送。部署清单保留在现有 Kubernetes 管理仓库，显式指定 `--context aliyun -n beagle-cloud-ide`；部署与验收记录归口 [Grok 变更记录](https://github.com/verdantflarehub/verdantflare-design/blob/dev/changes/change_20261011_grok_image_video.md)。

## 3. 补丁验证

`grok_scheduler_tier_test.go` 是上游 repository 包的单元回归测试。验证时在固定版本的临时测试目录应用补丁，将该测试文件放入 `backend/internal/repository/`，运行 `go test -tags unit ./internal/repository -run TestGrokSchedulerTierProjection -count=1`。该检查不依赖容器；测试目录不作为源码交付入口。

检查涵盖付费识别、免费降级、无令牌回退、损坏令牌回退、未知套餐、其他平台，以及缓存不泄露令牌和不修改完整账号。测试源码不进入运行镜像。
