# Jasna 镜像

基于 CUDA 12.8.1 构建的 [Jasna](https://github.com/Kruk2/jasna) 完整应用镜像。

Jasna 是一个 GPU 加速的视频马赛克检测与修复工具，基于 BasicVSR++ + TensorRT 实现超快速处理。

## 镜像信息

| 项目           | 说明                                                     |
| -------------- | -------------------------------------------------------- |
| **镜像地址**   | `registry.cn-qingdao.aliyuncs.com/wod/cuda:12.8.1-jasna` |
| **基础镜像**   | `nvidia/cuda:12.8.1-devel-ubuntu24.04`                   |
| **Jasna 版本** | `v0.6.0-alpha5`                                          |
| **Python**     | `3.13` (deadsnakes PPA)                                  |
| **PyTorch**    | `2.10.0+cu130`                                           |
| **TensorRT**   | `10.14.1`                                                |
| **架构**       | `linux/amd64`                                            |

## Dockerfile 构建流程 (Multi-stage)

镜像采用了多阶段构建以大幅降低最终体积：

1. **Stage 1 (Builder)**: 基于 `cuda:12.8.1-devel-ubuntu24.04` (由 `BUILDER_BASE` 指定)
   - 安装构建依赖 (cmake, ninja-build)
   - 编译和安装 TensorRT, PyTorch, vali, PyNvVideoCodec 等所有组件
2. **Stage 2 (Runtime)**: 基于 `cuda:12.8.1-runtime-ubuntu24.04` (由 `BASE` 指定)
   - 仅安装运行时必要的系统库 (ffmpeg, 渲染库)
   - 将 Builder 阶段产出的 Python 运行时、库和 Jasna 源码复制过来
   - 添加自定义 `entrypoint.sh` 支持模型预热 compiled

## 预装系统库 (Runtime 最终镜像)

- **多媒体**: `ffmpeg` `mkvtoolnix`
- **显示/渲染**: `libgl1` `libglib2.0-0` `libdrm2` `libx11-6`
- **VA-API**: `libva2` `libva-drm2` `libva-x11-2`
- **视频编解码**: `libvpx-dev` `libdav1d-dev` `libaom-dev` `libx264-dev` `libx265-dev` `libopenh264-dev` `libsvtav1enc-dev`
- **音频编解码**: `libmp3lame-dev` `libopus-dev` `libvorbis-dev`
- **图像/图形**: `libwebp-dev` `libjxl-dev` `libxml2` `librsvg2-2` `libcairo2`
- **着色器**: `libshaderc-dev`

## 构建

### CI 自动构建

推送到 `jasna` 分支即触发 GitHub Actions 自动构建：

```bash
git checkout jasna
git push origin jasna
```

### 本地构建

```bash
docker build \
  --build-arg BUILDER_BASE=nvidia/cuda:12.8.1-devel-ubuntu24.04 \
  --build-arg BASE=nvidia/cuda:12.8.1-runtime-ubuntu24.04 \
  --build-arg AUTHOR=open-beagle \
  --build-arg VERSION=12.8.1 \
  --build-arg JASNA_VERSION=v0.6.0-alpha5 \
  -t registry.cn-qingdao.aliyuncs.com/wod/cuda:12.8.1-jasna-v0.6.0-alpha5 \
  -f jasna/dockerfile \
  jasna/
```

## 使用方法

### 模型权重

运行前需要挂载模型权重到 `/app/jasna/model_weights/`：

| 文件                                             | 说明                  |
| ------------------------------------------------ | --------------------- |
| `lada_mosaic_restoration_model_generic_v1.2.pth` | BasicVSR++ 修复模型   |
| `rfdetr-v5.onnx`                                 | RF-DETR 检测模型      |
| `lada_mosaic_detection_model_v4_fast.pt`         | YOLO 检测模型（可选） |

模型权重可从 [Jasna Releases](https://github.com/Kruk2/jasna/releases) 下载。

### 提前编译 TensorRT 引擎 (Warmup)

TensorRT 引擎编译是**硬件绑定**的，因此无法在构建镜像时提前编译。但为避免首次处理时等待 15-60 分钟，此镜像提供了一个专门的 `warmup` 命令。
在部署机器上运行以下命令，即可提前编译当前主机的 GPU 引擎：

```bash
docker run -it --gpus all \
  -v /path/to/model_weights:/app/jasna/model_weights \
  registry.cn-qingdao.aliyuncs.com/wod/cuda:12.8.1-jasna-v0.6.0-alpha5 \
  warmup
```

_环境变量配置 (可选)_:

- `-e CLIP_SIZE=90` (默认由于 VRAM 大小限制决定，一般为 60, 90 或 180)
- `-e BATCH_SIZE=4`
- `-e DETECTION_MODEL=rfdetr-v5`

引擎会自动保存在挂载的 `model_weights/` 目录中，之后无论是 CLI 还是流媒体模式都不会再进行编译。

### CLI 处理视频

```bash
docker run --gpus all \
  -v /path/to/model_weights:/app/jasna/model_weights \
  -v /data:/data \
  registry.cn-qingdao.aliyuncs.com/wod/cuda:12.8.1-jasna-v0.6.0-alpha5 \
  --input /data/input.mp4 --output /data/output.mp4
```

### 流媒体模式

```bash
docker run --gpus all \
  -p 8765:8765 \
  -v /path/to/model_weights:/app/jasna/model_weights \
  -v /data:/data \
  registry.cn-qingdao.aliyuncs.com/wod/cuda:12.8.1-jasna-v0.6.0-alpha5 \
  --stream --stream-port 8765 --no-browser
```

### 硬件要求

- NVIDIA GPU，Compute Capability ≥ 7.5（Turing 及以上）
- NVIDIA 驱动 ≥ 590
- 建议 VRAM ≥ 8GB（4K 视频建议 12GB+）
- 首次运行时 TensorRT 引擎编译需要 15-60 分钟

## 参考

- **Jasna**: https://github.com/Kruk2/jasna
- **Lada** (上游): https://codeberg.org/ladaapp/lada
- **Vali** (GPU 视频解码): https://codeberg.org/Kruk2/vali
- **PyNvVideoCodec**: https://codeberg.org/Kruk2/PyNvVideoCodec
