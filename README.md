# 经验总结与规范

本项目不仅包含各类自动化脚本与配置，也沉淀了日常开发和运维过程中积累的核心经验。在本项目中新增内容或维护时，请遵循以下规范。

## 1. 子目录 README 规范

本仓库的**所有子目录**都必须包含一个 `README.md` 文件。这有助于团队成员快速理解该目录的用途、组件和使用方法。

推荐的 `README.md` 结构如下：

```markdown
# 目录名称 (如：ComfyUI 部署配置)

## 简介

一句话简要描述该目录的主要功能或存放的内容。

## 目录结构 (可选)

如果目录较复杂，建议列出核心的文件结构和各自的作用。

- `Dockerfile`: xxx 镜像构建文件
- `scripts/`: 启动与环境配置脚本

## 快速开始 / 使用说明

详细说明如何运行或使用该目录下的内容，提供明确的命令。
例如：构建镜像、启动容器、执行脚本的完整命令。

## 注意事项 & 经验踩坑

记录在此目录下开发或部署时容易踩坑的地方（如特定的环境依赖、需要替换的源、必须配置的环境变量等）。
```

## 2. 基础镜像源替换方案 (Ubuntu / Debian)

在编写 `Dockerfile` 或是配置 GitHub Actions 的 CI 脚本时，必须将 Ubuntu 和 Debian 的默认软件源进行替换。

### 为什么换？

因为在 GitHub Actions (或是 Azure 云) 环境中，由于并发请求量巨大，**Ubuntu 和 Debian 的默认官方源经常会对 GitHub Actions 的 IP 进行限流或封禁**。
如果不换源，`apt-get update` 极易出现网络超时、连接被拒绝（Connection refused）或 403 Forbidden 错误，导致 CI 频繁构建失败。由于 GitHub Actions 底层运行在 Azure 基础设施上，使用 Azure 的镜像源（或其 CDN 节点）既能享受内网级别的高速，又能避免被官方源拦截。

### 怎么换？

在你的 `Dockerfile` 执行 `apt-get update` 之前，添加如下源替换命令：

#### 对于 Ubuntu 镜像：

将默认源替换为 Azure 的 Ubuntu 源 (`azure.archive.ubuntu.com`)。

```bash
# 针对 Ubuntu 22.04 及更早版本 (传统 sources.list)
RUN sed -i 's/archive.ubuntu.com/azure.archive.ubuntu.com/g' /etc/apt/sources.list \
    && sed -i 's/security.ubuntu.com/azure.archive.ubuntu.com/g' /etc/apt/sources.list

# 针对 Ubuntu 24.04 及以后版本 (deb822 格式)
RUN if [ -f "/etc/apt/sources.list.d/ubuntu.sources" ]; then \
        sed -i 's/archive.ubuntu.com/azure.archive.ubuntu.com/g' /etc/apt/sources.list.d/ubuntu.sources; \
        sed -i 's/security.ubuntu.com/azure.archive.ubuntu.com/g' /etc/apt/sources.list.d/ubuntu.sources; \
    fi
```

#### 对于 Debian 镜像：

Debian 的默认源是 `deb.debian.org`。在 Azure/GitHub Actions 环境下，可以切换为微软 Azure 节点。

```bash
# 针对 Debian 11/12 (使用 sources.list 或 debian.sources)
# 替换为 Debian 的 Azure 流量管理器节点 (debian-archive.trafficmanager.net)
RUN sed -i 's/deb.debian.org/debian-archive.trafficmanager.net/g' /etc/apt/sources.list.d/debian.sources 2>/dev/null || \
    sed -i 's/deb.debian.org/debian-archive.trafficmanager.net/g' /etc/apt/sources.list
```
