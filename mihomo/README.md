# Mihomo 镜像

基于官方 `metacubex/mihomo` 构建的国内阿里云容器镜像。

## 1. 项目说明

- **镜像地址**：`registry.cn-qingdao.aliyuncs.com/wod/mihomo:v1.19.25`
- **基础镜像**：`metacubex/mihomo:v1.19.25`
- **项目特点**：
  - **时区优化**：通过重新打包，配置系统时区为 `Asia/Shanghai`，解决日志和定时任务时区偏差问题。
  - **多架构支持**：支持 `linux/amd64` 和 `linux/arm64` 平台。
  - **功能完整**：完美继承官方镜像的全部原生功能与运行机制。

### Mihomo 简介

Mihomo（原名 Clash.Meta）是一个用 Go 语言编写、支持规则的代理隧道。作为 Clash.Meta 核心的继任项目，它提供了对多种新型和高级协议的支持（例如 VLESS、Trojan、Hysteria、TUIC、Shadowsocks 等），并具备更强大的路由分流控制与高性能的网络处理能力。

## 2. GitHub 源码位置

- **Mihomo 官方源码仓库**：[MetaCubeX/mihomo](https://github.com/MetaCubeX/mihomo)
- **本仓库构建目录**：[mihomo/](file:///home/code/go/src/github.com/open-beagle/aliyun/mihomo)

## 3. 更新指令

推送到 `mihomo` 分支即可触发 GitHub Actions 自动构建和推送到阿里云镜像仓库：

```bash
git switch mihomo && \
  git merge main --ff-only && \
  git push origin mihomo && \
  git switch main
```

```powershell
git switch mihomo ;`
  git merge main --ff-only ;`
  git push origin mihomo ;`
  git switch main
```
