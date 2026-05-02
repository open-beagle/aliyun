#!/bin/bash
set -ex

# ============================================================
# Jasna 在容器内的自动化构建/调试脚本
# 用于进入基础镜像后，一键执行 Dockerfile 里的各步指令进行调试
# ============================================================

# 模拟 Dockerfile 环境变量
export DEBIAN_FRONTEND=noninteractive
export TZ=Asia/Shanghai
export LD_LIBRARY_PATH=/usr/local/lib/python3.13/site-packages/nvidia/nccl/lib:/usr/local/lib/python3.13/site-packages/nvidia/nccl/lib:/usr/local/cuda/lib64:${LD_LIBRARY_PATH}

echo ">>> 1. 安装构建工具 + 开发库..."
sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list.d/ubuntu.sources 2>/dev/null || true
sed -i 's/security.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list.d/ubuntu.sources 2>/dev/null || true
sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list 2>/dev/null || true
sed -i 's/security.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list 2>/dev/null || true
apt-get update && apt-get install -y --allow-change-held-packages --no-install-recommends \
    ca-certificates curl wget git \
    software-properties-common \
    cmake ninja-build upx-ucl \
    libavformat-dev libavcodec-dev libavutil-dev \
    libswscale-dev libswresample-dev \
    libgl1 libglib2.0-0 \
    libnccl2=2.28.9-1+cuda13.0 libnccl-dev=2.28.9-1+cuda13.0
rm -rf /var/lib/apt/lists/*

echo ">>> 2. 安装 Python 3.13 (使用官方预编译版本)..."
apt-get update && apt-get install -y --no-install-recommends curl ca-certificates
curl -fsSL https://github.com/actions/python-versions/releases/download/3.13.2-13708744326/python-3.13.2-linux-24.04-x64.tar.gz | tar -xz -C /usr/local
rm -rf /var/lib/apt/lists/*
update-alternatives --install /usr/bin/python3 python3 /usr/local/bin/python3.13 1 || true
update-alternatives --install /usr/bin/python python /usr/local/bin/python3.13 1 || true

echo ">>> 3. 安装 pip..."
curl -fsSL https://bootstrap.pypa.io/get-pip.py | python3.13
python3.13 -m pip config set global.index-url https://mirrors.aliyun.com/pypi/simple/
python3.13 -m pip install --no-cache-dir setuptools wheel scikit-build wheel-stub

# 下载 Jasna 源码进行后续编译
JASNA_SRC="/tmp/jasna_src"
echo ">>> 克隆 Jasna 源码..."
rm -rf "$JASNA_SRC"
git clone --depth=1 --branch v0.6.0-alpha5 https://github.com/Kruk2/jasna.git "$JASNA_SRC"
sed -i 's/if wrong_version:/if False:/g' "$JASNA_SRC/jasna/os_utils.py"

# 修复 blend_mask 在 crop 边界硬截断导致的正方形伪影
echo ">>> 应用 blend edge feather 补丁..."
python3.13 /app/jasna/patches/fix_blend_edge_feather.py "$JASNA_SRC/jasna"

cd "$JASNA_SRC"
WORKDIR=$(pwd)
echo ">>> 工作目录已切换至: $WORKDIR"

echo ">>> 4. 修复 PyInstaller 打包问题..."
sed -i 's/"PyNvVideoCodec", "python_vali", //g' jasna.spec || true
sed -i '/hiddenimports += h/a\    hiddenimports += ["python_vali", "PyNvVideoCodec"]' jasna.spec || true
python3.13 -c '
import pathlib
try:
    p = pathlib.Path("jasna.spec")
    txt = p.read_text()
    old = "trt_ext = find_spec(\"torch_tensorrt._C\")\nif trt_ext is not None and trt_ext.origin:\n    binaries += [(trt_ext.origin, \"torch_tensorrt\")]\n    hiddenimports += [\"torch_tensorrt._C\"]"
    new = "try:\n    trt_ext = find_spec(\"torch_tensorrt._C\")\n    if trt_ext is not None and trt_ext.origin:\n        binaries += [(trt_ext.origin, \"torch_tensorrt\")]\n        hiddenimports += [\"torch_tensorrt._C\"]\nexcept (ImportError, Exception):\n    pass"
    if old in txt:
        p.write_text(txt.replace(old, new))
except Exception:
    pass
' || true

echo ">>> 5. 清理残留 + 安装 PyTorch + TorchVision + nccl..."
# 清理可能被 Ctrl+C 中断导致损坏的 torch 安装残留
rm -rf /usr/local/lib/python3.13/site-packages/~orch* 2>/dev/null || true
pip install --no-cache-dir \
    torch==2.10.0+cu130 torchvision==0.25.0+cu130 \
    nvidia-nccl-cu13==2.28.9 \
    --extra-index-url https://download.pytorch.org/whl/cu130

echo ">>> 6. 安装 TensorRT..."
pip install --no-cache-dir \
    tensorrt==10.14.1.48.post1 \
    torch-tensorrt==2.10.0 \
    torch==2.10.0+cu130 \
    --extra-index-url https://download.pytorch.org/whl/cu130

echo ">>> 7. 安装自定义依赖 vali & PyNvVideoCodec..."
cd /tmp
rm -rf vali PyNvVideoCodec
git clone --recursive https://codeberg.org/Kruk2/vali.git
git clone https://codeberg.org/Kruk2/PyNvVideoCodec.git
pip install --no-cache-dir --no-build-isolation ./vali ./PyNvVideoCodec
cd "$WORKDIR"

echo ">>> 8. 安装 mmengine 并打补丁..."
pip install --no-cache-dir mmengine==0.10.7
MMENGINE_BASE=$(python3.13 -c "import mmengine, os; print(os.path.dirname(os.path.dirname(mmengine.__file__)))")
patch -p1 -d "$MMENGINE_BASE" < patches/fix_loading_mmengine_weights_on_torch26_and_higher.diff || true

echo ">>> 9. 安装 Jasna 自身依赖..."
pip install --no-cache-dir --no-build-isolation \
    --extra-index-url https://download.pytorch.org/whl/cu130 \
    --extra-index-url https://pypi.nvidia.com \
    .

echo ">>> 10. 生成独立二进制文件..."
pip install --no-cache-dir pyinstaller psutil cffi cryptography

# ---- 无 GPU 环境下修复 PyInstaller 的 NCCL / cryptography 崩溃 ----
# 问题: PyInstaller 会启动独立的子进程来分析依赖，这些子进程不继承 LD_LIBRARY_PATH。
#        torch._C 在 import 时需要加载 libnccl.so.2 并解析 ncclAlltoAll 符号。
#        系统 apt 安装的 libnccl2 包含该符号，但动态链接器缓存可能未更新。
#
# 修复1: 将 pip 安装的 NCCL 库路径写入 ldconfig 缓存，使所有子进程都能找到
echo "/usr/local/lib/python3.13/site-packages/nvidia/nccl/lib" > /etc/ld.so.conf.d/nccl-pip.conf
echo "/usr/local/lib/python3.13/site-packages/torch/lib" > /etc/ld.so.conf.d/torch.conf
ldconfig

# 修复2: 使用 LD_PRELOAD 强制预加载系统 NCCL 库（双保险）
NCCL_LIB=$(find /usr/lib -name "libnccl.so.2" 2>/dev/null | head -1)
if [ -z "$NCCL_LIB" ]; then
    NCCL_LIB=$(find /usr/local/lib/python3.13/site-packages/nvidia/nccl/lib -name "libnccl.so.2" 2>/dev/null | head -1)
fi
if [ -n "$NCCL_LIB" ]; then
    echo ">>> 使用 NCCL 库: $NCCL_LIB"
    export LD_PRELOAD="$NCCL_LIB"
fi

export CUDA_VISIBLE_DEVICES=""
export LD_LIBRARY_PATH=/usr/local/lib/python3.13/site-packages/nvidia/nccl/lib:/usr/local/lib/python3.13/site-packages/torch/lib:/usr/lib/x86_64-linux-gnu:${LD_LIBRARY_PATH}

# 创建模型文件和资源占位符（build_exe.py 会尝试复制它们）
mkdir -p model_weights assets
touch model_weights/lada_mosaic_restoration_model_generic_v1.2.pth 2>/dev/null || true
touch model_weights/rfdetr-v5.onnx 2>/dev/null || true
touch model_weights/lada_mosaic_detection_model_v4_fast.pt 2>/dev/null || true
touch assets/test_clip1_1080p.mp4 2>/dev/null || true
touch assets/test_clip1_2160p.mp4 2>/dev/null || true

python3.13 build_exe.py
mkdir -p dist_linux/jasna/_internal/PyNvVideoCodec
find /usr/local/lib/python3.13 -name "PyNvVideoCodec_*.so" -exec cp {} dist_linux/jasna/_internal/PyNvVideoCodec/ \;
mkdir -p dist_linux/jasna/_internal/python_vali
find /usr/local/lib/python3.13 -name "python_vali*.so" -exec cp {} dist_linux/jasna/_internal/python_vali/ \;

# 将生成的二进制复制回挂载的主机目录
HOST_DIR="/app/jasna"
rm -rf "$HOST_DIR/dist_linux"
mkdir -p dist_linux/jasna/model_weights
cp -r dist_linux "$HOST_DIR/"

echo "============================================================"
echo "✅ 容器内编译与提取完成，结果已拷贝到宿主机的 jasna/dist_linux 目录！"
echo "============================================================"
