# ComfyUI

## Github 地址

- 上游项目：https://github.com/comfyanonymous/ComfyUI
- ComfyUI-Manager：https://github.com/ltdrdata/ComfyUI-Manager

## 迭代命令

```bash
git switch comfyui && \
  git merge main --ff-only && \
  git push origin comfyui && \
  git switch main
```

```powershell
git switch comfyui ;`
  git merge main --ff-only ;`
  git push origin comfyui ;`
  git switch main
```

## 概述

本目录用于构建 ComfyUI 镜像，基于 `nvidia/cuda` 镜像安装 Python、PyTorch cu130、ComfyUI 和 ComfyUI-Manager，并将默认监听地址调整为 `0.0.0.0`，默认运行目录调整为 `/data`。

GitHub Actions 工作流位于 `.github/workflows/comfyui.yml`，推送 `comfyui` 分支或手动触发时构建。当前构建版本为 `v0.25.1`，CUDA 版本为 `13.0.3`，构建 `linux/amd64` 镜像并推送到：

- `registry.cn-qingdao.aliyuncs.com/wod/comfyui:v0.25.1-cu13.0.3`

### 启动探活

- 容器启动后由 `/app/entrypoint.sh` 初始化 ComfyUI-Manager `file_logging = True`，让 ComfyUI/Manager 自己把日志写到用户目录下的固定文件。
- 镜像构建时把 ComfyUI 默认监听地址改为 `0.0.0.0`，默认运行目录改为 `/data`，因此 Manager 触发 Restart 时仍会使用 `/data/models`、`/data/output`、`/data/input` 和 `/data/user`。
- `/app/models` 整体软链接到 `/data/models`，模型数据只保存在持久化卷中。
- 脚本后台启动 ComfyUI，不把 `python main.py` 的输出重定向到目标日志文件；前台只 `tail -F` ComfyUI-Manager 实际写入的日志文件，同步输出到容器日志。
- ComfyUI Manager 自身的重启指令由 ComfyUI 进程处理，容器层不重复接管；如果重启失败，多半是业务问题，由 Kubernetes 探活判定并重启。
- Kubernetes `startupProbe` 每 10 秒访问一次 `http://:8188/`，最多失败 30 次；启动超过 5 分钟仍不可访问时，判定启动失败。
- Kubernetes `readinessProbe` 用于标记服务是否可接收流量。
- Kubernetes `livenessProbe` 每 10 秒访问一次 `http://:8188/`，连续失败 3 次后重启容器，失败窗口约 30 秒。

可调环境变量：

- `COMFYUI_LOG_FILE`：兼容旧环境变量。ComfyUI-Manager file logging 不支持自定义文件路径，脚本会始终使用它实际写入的路径：`/data/user/comfyui_8188.log`。
- `COMFYUI_STDIO_LOG_FILE`：后台 `python main.py` 的 stdout/stderr 临时日志，默认 `/tmp/comfyui-stdio.log`。
