# ComfyUI

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

## ComfyUI 启动探活

- 容器启动后由 `/app/entrypoint.sh` 初始化 ComfyUI-Manager `file_logging = True`，让 ComfyUI/Manager 自己把日志写到固定文件。
- 脚本后台启动 ComfyUI，然后前台 `tail -F` 这个日志文件，同步输出到容器日志；手动启动或 Manager 重启后，只要继续写同一路径，容器日志就能继续看到。
- ComfyUI Manager 自身的重启指令由 ComfyUI 进程处理，容器层不重复接管；如果重启失败，多半是业务问题，由 Kubernetes 探活判定并重启。
- Kubernetes `startupProbe` 每 10 秒访问一次 `http://:8188/`，最多失败 30 次；启动超过 5 分钟仍不可访问时，判定启动失败。
- Kubernetes `readinessProbe` 用于标记服务是否可接收流量。
- Kubernetes `livenessProbe` 每 10 秒访问一次 `http://:8188/`，连续失败 3 次后重启容器，失败窗口约 30 秒。

可调环境变量：

- `COMFYUI_PORT`：ComfyUI 监听端口，默认 `8188`。
- `COMFYUI_LOG_FILE`：ComfyUI-Manager file logging 日志路径；K8s `/data` 模式默认 `/data/user/comfyui_8188.log`，普通模式默认 `/app/user/comfyui_8188.log`。
