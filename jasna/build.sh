#!/bin/bash
set -ex

# ============================================================
# Jasna 在容器内的自动化构建/调试脚本
# 用于进入基础镜像后，一键执行 Dockerfile 里的各步指令进行调试
# ============================================================

# 模拟 Dockerfile 环境变量
export DEBIAN_FRONTEND=noninteractive
export TZ=Asia/Shanghai
export LD_LIBRARY_PATH=/usr/local/lib/python3.13/dist-packages/nvidia/nccl/lib:/usr/local/lib/python3.13/site-packages/nvidia/nccl/lib:/usr/local/cuda/lib64:${LD_LIBRARY_PATH}

echo ">>> 1. 安装构建工具 + 开发库..."
apt-get update && apt-get install -y --allow-change-held-packages --no-install-recommends \
    ca-certificates curl wget git \
    software-properties-common \
    cmake ninja-build upx-ucl \
    libavformat-dev libavcodec-dev libavutil-dev \
    libswscale-dev libswresample-dev \
    libnccl2=2.28.9-1+cuda13.0 libnccl-dev=2.28.9-1+cuda13.0
rm -rf /var/lib/apt/lists/*

echo ">>> 2. 安装 Python 3.13..."
add-apt-repository -y ppa:deadsnakes/ppa
apt-get update && apt-get install -y --no-install-recommends \
    python3.13 python3.13-venv python3.13-dev
rm -rf /var/lib/apt/lists/*
update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.13 1 || true
update-alternatives --install /usr/bin/python python /usr/bin/python3.13 1 || true

echo ">>> 3. 安装 pip..."
curl -fsSL https://bootstrap.pypa.io/get-pip.py | python3.13
python3.13 -m pip install --no-cache-dir setuptools wheel scikit-build wheel-stub

# 进到 jasna 源码目录进行后续编译 (假设外部已挂载且当前在相关目录)
# 由于你的 docker run 也是挂载本地执行的，这里直接 cd 进目录
cd "$(dirname "$0")"
WORKDIR=$(pwd)
echo ">>> 工作目录已切换至: $WORKDIR"

echo ">>> 4. 修复 PyInstaller 打包问题..."
sed -i 's/"PyNvVideoCodec", "python_vali", //g' jasna.spec || true
sed -i '/hiddenimports += h/a\    hiddenimports += ["python_vali", "PyNvVideoCodec"]' jasna.spec || true
python3.13 -c "import pathlib; p=pathlib.Path('jasna.spec'); txt=p.read_text(); \
old='trt_ext = find_spec(\"torch_tensorrt._C\")\nif trt_ext is not None and trt_ext.origin:\n    binaries += [(trt_ext.origin, \"torch_tensorrt\")]\n    hiddenimports += [\"torch_tensorrt._C\"]'; \
new='try:\n    trt_ext = find_spec(\"torch_tensorrt._C\")\n    if trt_ext is not None and trt_ext.origin:\n        binaries += [(trt_ext.origin, \"torch_tensorrt\")]\n        hiddenimports += [\"torch_tensorrt._C\"]\nexcept (ImportError, Exception):\n    pass'; \
if old in txt: p.write_text(txt.replace(old, new))" || true

echo ">>> 5. 安装 PyTorch + TorchVision + nccl..."
pip install --no-cache-dir \
    torch==2.10.0+cu130 torchvision==0.25.0+cu130 \
    nvidia-nccl-cu13==2.28.9 \
    --extra-index-url https://download.pytorch.org/whl/cu130

echo ">>> 6. 安装 TensorRT..."
pip install --no-cache-dir \
    tensorrt==10.14.1.48.post1 \
    torch-tensorrt==2.10.0

echo ">>> 7. 安装自定义依赖 vali & PyNvVideoCodec..."
cd /tmp
rm -rf vali PyNvVideoCodec
git clone https://codeberg.org/Kruk2/vali.git
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
    .

echo ">>> 10. 生成独立二进制文件..."
pip install --no-cache-dir pyinstaller psutil
BUILD_CLI=1 python3.13 build_exe.py
mv dist_linux/jasna/jasna-cli dist_linux/jasna/jasna || true

echo "============================================================"
echo "✅ 容器内编译与提取完成，结果保存在 dist_linux/jasna 目录！"
echo "============================================================"
