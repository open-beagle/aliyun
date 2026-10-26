# open-beagle/aliyun 子目录文档与分支操作规范 (AGENTS.md)

本文档定义本仓库中所有组件子目录 `README.md` 的标准化规范、文档结构要求及配套的 Git 分支操作铁律。所有开发者与 AI 智能体（Agents）在新增、修改或重构任意子目录时必须严格遵守。

---

## 1. 项目分支模型与流转规范 (Branching Workflow)

本仓库采用“主干 + 组件触发分支”的多分支构建模型：

### 1.1 分支角色定义

- **`main`**：项目唯一主干与发布基准线（Single Source of Truth），日常开发、补丁编写与功能自测均在 `main` 完成，保障历史纯粹。
- **`<component_branch>`**：组件 CI 构建专用触发指针（如 `sub2api`、`redis-7` 等 40+ 分支），不承载日常提交。

### 1.2 标准流转两步法 (简洁闭环)

1. **主干开发与推送**：在 `main` 分支完成编码、自测并推送：
   ```bash
   git switch main && git push origin main
   ```
2. **强制对齐触发构建**：触发分支通过 `reset --hard` 镜像级对齐主干并强推（**严禁常规 merge**）：
   ```bash
   git switch <service_branch> && git reset --hard main && git push origin <service_branch> --force && git switch main
   ```

---

## 2. 子目录文档应该做什么 (What to Do)

本仓库的每一个子目录代表一个独立的容器镜像构建单元。为了保障全仓库风格一致、协作透明且 CI/CD 流程稳定，每个子目录下的 `README.md` 必须自包含并满足以下要求：

### 2.1 必须包含的标准段落 (顺序严格固定)

1. **一级标题 (`# <组件名>`)**：必须以清晰的组件英文名或服务名作为一级标题。
2. **安全防护警示引用块 (Banner)**：顶部必须声明强制性规则，明确主分支与触发分支的权责边界。
3. **操作铁律 (`## 🚫 严禁事项与操作铁律`)**：列出针对该组件触发分支的三条操作红线。
4. **上游地址 (`## Github 地址` 或 `## 上游项目`)**：提供清晰的上游源码仓库及 Docker Hub / 官方镜像链接。
5. **标准迭代与强制对齐命令 (`## 🔄 标准迭代与强制对齐命令`)**：同时提供 Bash 与 PowerShell 格式的对齐脚本，脚本必须通过 `git reset --hard main` 保证触发分支历史与主干严格镜像级对齐。
6. **概述与镜像构建说明 (`## 📌 概述与镜像构建说明`)**：
   - 明确镜像定位、基础底座镜像、关键定制内容（如 `Asia/Shanghai` 时区、CA 证书、源码补丁、预置依赖等）。
   - 明确指向对应的 GitHub Actions 工作流文件路径（`.github/workflows/<workflow>.yml`）及分支触发条件。
   - 声明当前构建版本号（Build Version）及目标架构（如 `linux/amd64,linux/arm64`）。
   - 明确列出推送到阿里云容器镜像服务（ACR）的完整镜像地址及 Tags 列表。
   - 说明多架构 Manifest（无架构后缀的聚合 Tag）的行为。

### 2.2 可选扩展段落 (视组件特性按需添加)

- **`## 目录结构`**：当子目录下存在多个 Dockerfile、源码补丁文件或辅助构建脚本时，提供 ASCII 目录树并对核心文件进行注解说明。
- **`## 补丁验证与回归测试`**：当包含定制 patch 或单元测试代码时，给出本地或容器外的测试验证步骤与明确的测试命令。
- **`## 启动探活与配置`**：若镜像在 Kubernetes 部署中配置了特殊的 `startupProbe`、`readinessProbe`、`livenessProbe` 或对外暴露的可调节环境变量，必须在此说明参数意义与默认值。
- **`## 使用示例`**：提供一键运行该镜像的 `docker run` 示例命令。

---

## 3. 不应该做什么 (What NOT to Do)

### 3.1 文档编写禁忌

1. 🚫 **严禁省略顶部警示引用块**：严禁私自移除 `🚨 【强制性规则】绝对禁止直接在触发分支上发起任何提交或修改！` 警示条。
2. 🚫 **严禁省略或弱化“严禁事项与操作铁律”**：必须完整保留三条铁律，不得随意裁减。
3. 🚫 **严禁随意自创非标标题结构**：不得使用如 `## 1. 版本与补丁`、`## 2. 开发与交付` 等非标标题破坏仓库通用的导航体系。
4. 🚫 **严禁遗漏多架构镜像 Tags 清单**：不得只写一个笼统的镜像名称，必须完整列出聚合 Tag 以及各架构分 Tag（`-amd64`, `-arm64`）。
5. 🚫 **严禁在组件文档中脱离仓库分支模式**：不得在子目录 README 中宣称“本目录不再使用触发分支”、“改为直接推 release”等违背本仓库“单组件专用分支触发 CI”统一模式的内容。

### 3.2 Git 分支操作禁忌

1. 🚫 **严禁在组件触发分支直接提交修改**：所有 Dockerfile、配置、补丁和 README 的修改必须且只能在 `main` 分支上提交。
2. 🚫 **严禁产生脏 Merge 提交**：在触发分支遇到任何冲突、历史分叉或 `refusing to merge unrelated histories` 时，**严禁**使用常规 `git merge`，更不得使用 `--allow-unrelated-histories` 强行合并。
3. 🚫 **严禁破坏触发分支的镜像纯粹性**：触发分支仅作为 GitHub Actions 的触发指针，其 HEAD 必须通过 `git reset --hard main` 始终 100% 对齐主分支。

---

## 4. 怎么做 (How to Do It)

### 4.1 标准命令模板

触发分支标准对齐命令格式如下：

#### Bash

```bash
git switch <service_branch> && \
  git reset --hard main && \
  git push origin <service_branch> --force && \
  git switch main
```

#### PowerShell

```powershell
git switch <service_branch> ;`
  git reset --hard main ;`
  git push origin <service_branch> --force ;`
  git switch main
```

### 4.2 子目录 README.md 完整复用模板

新增或重构任意子目录时，直接复制以下模板进行内容填空：

````markdown
# <组件英文名/服务名>

> 🚨 **【强制性规则】绝对禁止直接在触发分支上发起任何提交或修改！**  
> 所有配置变更、镜像版本升级必须且只能在 `main` 分支完成。触发分支仅作为 CI/CD 自动构建的专用触发分支。

---

## 🚫 严禁事项与操作铁律

1. **禁止直接 Commit**：不得擅自在构建分支修改 Dockerfile、README 或工作流。
2. **禁止产生脏 Merge 提交**：若出现 `refusing to merge unrelated histories` 报错，**严禁**使用常规 `git merge` 或乱加参数强行合并，必须统一使用 `git reset --hard main` 强制对齐主干历史！
3. **保持提交历史纯粹**：触发分支的 HEAD 必须镜像级对齐 `main` 分支。

---

## Github 地址

- 上游项目：https://github.com/<upstream_org>/<upstream_repo>
- 上游镜像：https://hub.docker.com/r/<upstream_image> (如有)

## 🔄 标准迭代与强制对齐命令

### Bash

```bash
git switch <service_branch> && \
  git reset --hard main && \
  git push origin <service_branch> --force && \
  git switch main
```

### PowerShell

```powershell
git switch <service_branch> ;`
  git reset --hard main ;`
  git push origin <service_branch> --force ;`
  git switch main
```

## 📌 概述与镜像构建说明

本目录用于构建 <组件名> 镜像，基于 <基础镜像与版本> 进行定制开发，主要包含：

- ...

GitHub Actions 工作流位于 `.github/workflows/<workflow_name>.yml`，推送 `<service_branch>` 分支或手动触发工作流时执行构建。当前构建版本为 `<version>`，会构建 `linux/amd64` 和 `linux/arm64` 镜像，并推送到：

- `registry.cn-qingdao.aliyuncs.com/wod/<image_name>:<version>`
- `registry.cn-qingdao.aliyuncs.com/wod/<image_name>:<version>-amd64`
- `registry.cn-qingdao.aliyuncs.com/wod/<image_name>:<version>-arm64`

其中不带架构后缀的版本标签为多平台镜像，可按运行环境自动选择架构。

<!-- 可选章节根据实际情况追加： -->
<!-- ## 目录结构 -->
<!-- ## 补丁验证与回归测试 -->
<!-- ## 启动探活与配置 -->
<!-- ## 使用示例 -->
````
