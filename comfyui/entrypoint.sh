#!/bin/bash
set -e

# 为 K8s 部署优化：如果存在 /data 挂载点，自动初始化目录结构
if [ -d "/data" ]; then
    echo "=========================================="
    echo "🚀 检测到 /data 持久化卷，正在初始化 K8s 存储结构..."
    echo "=========================================="
    
    mkdir -p /data/output
    mkdir -p /data/input
    mkdir -p /data/user/default/workflows
    mkdir -p /data/models
    
    # 配置额外模型路径
    if [ ! -f "/app/extra_model_paths.yaml" ]; then
        echo "创建 extra_model_paths.yaml 连接到 /data/models"
        cat <<EOF > /app/extra_model_paths.yaml
k8s_storage:
    base_path: /data/models
    checkpoints: checkpoints
    configs: configs
    loras: loras
    vae: vae
    clip: clip
    unet: unet
    clip_vision: clip_vision
    style_models: style_models
    embeddings: embeddings
    diffusers: diffusers
    vae_approx: vae_approx
    controlnet: controlnet
    gligen: gligen
    upscale_models: upscale_models
    custom_nodes: custom_nodes
    hypernetworks: hypernetworks
    photomaker: photomaker
    ipadapter: ipadapter
EOF
    fi

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
    
    # 替换运行参数中的目录挂载
    exec python main.py --listen 0.0.0.0 --port 8188 \
        --output-directory /data/output \
        --input-directory /data/input \
        --user-directory /data/user \
        "\$@"
else
    echo "未检测到 /data 挂载点，使用标准模式启动..."
    exec python main.py --listen 0.0.0.0 --port 8188 "\$@"
fi
