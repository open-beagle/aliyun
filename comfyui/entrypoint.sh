#!/bin/bash
set -e

COMFYUI_LOG_FILE="${COMFYUI_LOG_FILE:-}"
COMFYUI_PID=""
COMFYUI_STDIO_LOG_FILE="${COMFYUI_STDIO_LOG_FILE:-/tmp/comfyui-stdio.log}"

configure_manager_logging() {
    local user_dir="$1"
    local config_file

    for config_file in \
        "$user_dir/__manager/config.ini" \
        "$user_dir/default/ComfyUI-Manager/config.ini"; do
        mkdir -p "$(dirname "$config_file")"

        if [ ! -f "$config_file" ]; then
            cat <<EOF > "$config_file"
[default]
file_logging = True
EOF
        elif grep -q '^file_logging[[:space:]]*=' "$config_file"; then
            sed -i 's/^file_logging[[:space:]]*=.*/file_logging = True/' "$config_file"
        else
            printf '\nfile_logging = True\n' >> "$config_file"
        fi
    done
}

stop_comfyui() {
    echo "收到停止信号，正在停止 ComfyUI..."

    if [ -n "$COMFYUI_PID" ] && kill -0 "$COMFYUI_PID" 2>/dev/null; then
        kill "$COMFYUI_PID" 2>/dev/null || true
        wait "$COMFYUI_PID" 2>/dev/null || true
    fi

    exit 0
}

show_comfyui_log() {
    mkdir -p "$(dirname "$COMFYUI_LOG_FILE")"
    touch "$COMFYUI_LOG_FILE"

    echo "ComfyUI 日志文件: $COMFYUI_LOG_FILE"
    echo "开始监控 ComfyUI 日志..."

    tail -n 0 -F "$COMFYUI_LOG_FILE"
}

set_comfyui_log_file() {
    local user_dir="$1"
    local manager_log_file="$user_dir/comfyui_8188.log"

    if [ -n "$COMFYUI_LOG_FILE" ] && [ "$COMFYUI_LOG_FILE" != "$manager_log_file" ]; then
        echo "警告: ComfyUI-Manager file_logging 不支持自定义日志文件路径，忽略 COMFYUI_LOG_FILE=$COMFYUI_LOG_FILE"
        echo "将使用 ComfyUI-Manager 实际日志文件: $manager_log_file"
    fi

    COMFYUI_LOG_FILE="$manager_log_file"
    export COMFYUI_LOG_FILE
}

image_env_id() {
    python - <<'PY'
import hashlib
import pathlib
import platform
import sys

parts = [
    f"python={platform.python_version()}",
    f"executable={sys.executable}",
]
for file_name in ("requirements.txt", "comfy_execution/graph_utils.py"):
    path = pathlib.Path("/app") / file_name
    if path.exists():
        parts.append(f"{file_name}={hashlib.sha256(path.read_bytes()).hexdigest()}")

print("|".join(parts))
PY
}

trap stop_comfyui TERM INT

echo "=========================================="
echo "正在初始化 K8s 存储结构..."
echo "=========================================="

mkdir -p /data/output
mkdir -p /data/input
mkdir -p /data/user/default/workflows
mkdir -p /data/user/default/comfyui
mkdir -p /data/user/default/ComfyUI-Manager
mkdir -p /data/models
mkdir -p /data/custom_nodes

if ! touch /data/user/.write-test 2>/dev/null; then
    echo "错误: /data/user 不可写，ComfyUI 无法创建配置和数据库文件。请检查 PVC 权限。"
    exit 1
fi
rm -f /data/user/.write-test

# ComfyUI 的默认模型目录仍是 /app/models；这里把整个目录指向 /data/models。
if [ -e "/app/models" ] && [ ! -L "/app/models" ]; then
    rm -rf /app/models
fi
ln -sfn /data/models /app/models

# 将自定义节点目录放到持久化卷中。ComfyUI 仍然读取 /app/custom_nodes，
# 但实际内容通过软链接保存到 /data/custom_nodes，避免 Pod 重建后丢失。
if [ -d "/app/custom_nodes" ] && [ ! -L "/app/custom_nodes" ]; then
    if [ -z "$(ls -A /data/custom_nodes)" ]; then
        echo "初始化自定义节点目录到 /data/custom_nodes..."
        cp -a /app/custom_nodes/. /data/custom_nodes/
    elif [ -d "/app/custom_nodes/ComfyUI-Manager" ] && [ ! -d "/data/custom_nodes/ComfyUI-Manager" ]; then
        echo "补充 ComfyUI-Manager 到持久化自定义节点目录..."
        cp -a /app/custom_nodes/ComfyUI-Manager /data/custom_nodes/
    fi

    rm -rf /app/custom_nodes
    ln -s /data/custom_nodes /app/custom_nodes
fi

# 将后续通过 ComfyUI-Manager 安装的 Python 依赖放到持久化 venv 中。
# 使用 --system-site-packages 复用镜像内置的 CUDA PyTorch 和 ComfyUI 基础依赖。
IMAGE_ENV_ID="$(image_env_id)"
if [ -x "/data/venv/bin/python" ] && { [ ! -f "/data/venv/.image-env-id" ] || [ "$(cat /data/venv/.image-env-id)" != "$IMAGE_ENV_ID" ]; }; then
    echo "检测到持久化 Python venv 与当前镜像环境不一致，重建: /data/venv"
    rm -rf /data/venv
fi

if [ ! -x "/data/venv/bin/python" ]; then
    echo "创建持久化 Python venv: /data/venv"
    python -m venv --system-site-packages /data/venv
    /data/venv/bin/python -m pip install --no-cache-dir --upgrade pip uv
    printf '%s\n' "$IMAGE_ENV_ID" > /data/venv/.image-env-id
fi

export VIRTUAL_ENV=/data/venv
export PATH="/data/venv/bin:$PATH"

# 自动把容器自带的一些默认工作流(如果有的话)拷贝到挂载的用户目录，避免持久化覆盖导致工作流丢失
# 新版 ComfyUI 会将 UI 设置和默认工作流保存在 user 目录
if [ -d "/app/user/default/workflows" ] && [ -z "$(ls -A /data/user/default/workflows)" ]; then
    echo "初始化自带的默认工作流到持久化目录..."
    cp -r /app/user/default/workflows/* /data/user/default/workflows/ 2>/dev/null || true
fi

echo "K8s 存储结构初始化完成。"
echo "模型目录: /data/models"
echo "输出目录: /data/output"
echo "输入目录: /data/input"
echo "用户配置与工作流: /data/user"

configure_manager_logging /data/user
set_comfyui_log_file /data/user

echo "后台启动 ComfyUI..."
echo "ComfyUI 标准输出日志: $COMFYUI_STDIO_LOG_FILE"
/data/venv/bin/python main.py "$@" >"$COMFYUI_STDIO_LOG_FILE" 2>&1 &
COMFYUI_PID="$!"
show_comfyui_log
