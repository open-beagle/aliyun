# Jasna 镜像

基于 CUDA 13.0.3 构建的 [Jasna](https://github.com/Kruk2/jasna) 完整应用镜像。

Jasna 是一个 GPU 加速的视频马赛克检测与修复工具，基于 BasicVSR++ + TensorRT 实现超快速处理。

## 镜像信息

| 项目           | 说明                                                     |
| -------------- | -------------------------------------------------------- |
| **镜像地址**   | `registry.cn-qingdao.aliyuncs.com/wod/cuda:13.0.3-jasna` |
| **基础镜像**   | `nvidia/cuda:13.0.3-devel-ubuntu24.04`                   |
| **Jasna 版本** | `v0.6.0-alpha5`                                          |
| **Python**     | `3.13` (deadsnakes PPA)                                  |
| **PyTorch**    | `2.10.0+cu130`                                           |
| **TensorRT**   | `10.14.1`                                                |
| **架构**       | `linux/amd64`                                            |

## Dockerfile 构建流程 (拆分构建)

镜像采用了拆分构建的方式以大幅降低最终体积（将原本高达 9.4GB+ 的镜像层优化缩减至 2GB 左右）：

1. **生成二进制 (dockerfile.build)**: 基于 `cuda:13.0.3-devel-ubuntu24.04`
   - 安装构建依赖 (cmake, ninja-build, upx-ucl 等打包工具)
   - 编译和安装 TensorRT, PyTorch, vali, PyNvVideoCodec 等所有组件
   - 运行 PyInstaller 以及 UPX 压缩进程，打成完全独立的二进制文件夹并在流水线中被提炼出容器。

2. **打包镜像 (dockerfile)**: 基于 `cuda:13.0.3-runtime-ubuntu24.04`
   - 仅安装运行时必要的系统库 (ffmpeg, 渲染库)
   - 彻底移除了庞大臃肿的 Python 以及 Site-packages
   - 直接打包宿主机提炼好的单体二进制 `dist_jasna` 以启动应用

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
git switch jasna && \
  git merge main --ff-only && \
  git push origin jasna && \
  git switch main
```

```powershell
git switch jasna ;`
  git merge main --ff-only ;`
  git push origin jasna ;`
  git switch main
```

### 本地构建

为了在本地进行与 CI 一致的构建，请依次执行以下两条构建分离逻辑：

```bash
# 1. 本地交互式调试 (手动逐行排查 build 阶段错误)
docker run -it --rm \
  --name jasna-builder \
  -v "$(pwd)/jasna:/app/jasna" \
  -w /app \
  registry.cn-qingdao.aliyuncs.com/wod/cuda:13.0.3-devel-ubuntu24.04 \
  /bin/bash jasna/build.sh

# 进入容器后，你可以手动执行 dockerfile.build 中的每一行 RUN 命令，排查具体的报错位置：
# 例如: apt-get update && apt-get install ...
# 例如: cd /tmp && git clone https://codeberg.org/Kruk2/vali.git ...

# ----------------------------------------
# 如果你排查完毕确认无误，再使用正常方式提取由于（以下为提取步骤，需在此前完成 build/手动操作并提交为新镜像或在此前将生成物导出）：
# docker cp jasna-builder-debug:/app/jasna/dist_linux/jasna jasna/dist_jasna
```

# 2. 打包最终发布镜像

```bash
docker build \
  --build-arg BASE=nvidia/cuda:13.0.3-runtime-ubuntu24.04 \
  --build-arg AUTHOR=open-beagle \
  --build-arg VERSION=13.0.3 \
  -t registry.cn-qingdao.aliyuncs.com/wod/cuda:13.0.3-jasna-v0.6.0-alpha5 \
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
docker run -it \
  --device nvidia.com/gpu=0 \
  -v /path/to/model_weights:/app/jasna/model_weights \
  registry.cn-qingdao.aliyuncs.com/wod/cuda:13.0.3-jasna-v0.6.0-alpha5 \
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
  registry.cn-qingdao.aliyuncs.com/wod/cuda:13.0.3-jasna-v0.6.0-alpha5 \
  --input /data/input.mp4 --output /data/output.mp4
```

### 流媒体模式

```bash
docker run --gpus all \
  -p 8765:8765 \
  -v /path/to/model_weights:/app/jasna/model_weights \
  -v /data:/data \
  registry.cn-qingdao.aliyuncs.com/wod/cuda:13.0.3-jasna-v0.6.0-alpha5 \
  --stream --stream-port 8765 --no-browser
```

### 硬件要求

- NVIDIA GPU，Compute Capability ≥ 7.5（Turing 及以上）
- NVIDIA 驱动 ≥ 590
- 建议 VRAM ≥ 8GB（4K 视频建议 12GB+）
- 首次运行时 TensorRT 引擎编译需要 15-60 分钟

## 常见问题与优化 (Troubleshooting & Optimization)

### 1. 马赛克边缘“漏边/闪烁”圈 (Mosaic Edge Ring Flickering)

在处理部分视频（特别是边缘存在大范围模糊光晕的马赛克）时，您可能会观察到**马赛克边缘有一圈明显的马赛克间歇性闪烁**。这通常是因为检测模型框选得过于紧凑（Mask Margin 不足），导致部分边缘的马赛克像素未能送入 BasicVSR++ 进行处理。

**底层的硬编码优化：**
为了彻底解决此问题，我们在 `dockerfile.build` 与 `build.sh` 的编译阶段打入了热修复补丁，动态修改了 `jasna/crop_buffer.py` 中的边界扩展量：

- `BORDER_RATIO`: 从默认的 `0.06` 放大至 `0.15` (15%)
- `MIN_BORDER`: 从默认的 `20` 放大至 `40` (像素)
  这使得模型在裁切时会更加“贪婪”地向四周多抓取 40 像素或 15% 面积的内容，确保彻底包住光晕边缘。

**运行时的配合优化（推荐）：**
除了底层边界放大，建议在启动时通过 `EXTRA_ARGS` 配合降低检测阈值与增加时间重叠，以增强画面稳定性：

```bash
-e EXTRA_ARGS="--detection-score-threshold 0.15 --temporal-overlap 15"
```

降低阈值能防止检测框在困难帧中丢失或收缩，增加时间重叠（推荐 15）能有效解决大范围动态场景下的时间边界断层。

## 参考

- **Jasna**: https://github.com/Kruk2/jasna
- **Lada** (上游): https://codeberg.org/ladaapp/lada
- **Vali** (GPU 视频解码): https://codeberg.org/Kruk2/vali
- **PyNvVideoCodec**: https://codeberg.org/Kruk2/PyNvVideoCodec
