# Video2X (Aliyun Mirror)

此目录包含了同步 `ghcr.io/k4yt3x/video2x` 到阿里云容器镜像服务的相关配置。

## 如何运行

您可以通过以下命令使用阿里云镜像运行 Video2X。Video2X 6.4.0 的 GitHub Release 页面不单独提供模型下载，模型文件在源码仓库的 `models/` 目录里。建议先把需要的模型下载到宿主机目录，再挂载到容器内的 `/usr/share/video2x`。

### 运行示例

```bash
# 创建一个本地目录用于存放模型
MODEL_DIR=/path/to/your/local/video2x_models
mkdir -p "$MODEL_DIR/models/realesrgan"

# 运行 Video2X 并挂载模型目录和工作目录
docker run --device nvidia.com/gpu=0 -it --rm \
  -e NVIDIA_DRIVER_CAPABILITIES=all \
  -v "$PWD":/host \
  -v "$MODEL_DIR":/usr/share/video2x \
  registry.cn-qingdao.aliyuncs.com/wod/video2x:6.4.0 \
  -i /host/input.mp4 \
  -o /host/output_1080p.mp4 \
  -p realesrgan \
  -s 4 \
  --realesrgan-model realesrgan-plus
```

### 批量转换 data 目录

镜像入口会扫描容器内 `/data` 目录下的 `*.mp4` 文件，找出高度低于 `1080p` 的视频，先列出任务清单，再逐个转换为同目录下的 `*_1080p.mp4`。

```bash
docker run --device nvidia.com/gpu=0 -it --rm \
  -e NVIDIA_DRIVER_CAPABILITIES=all \
  -v "$PWD/data":/data \
  -v /path/to/your/local/video2x_models:/usr/share/video2x \
  registry.cn-qingdao.aliyuncs.com/wod/video2x:6.4.0
```

可通过环境变量调整默认参数：

```bash
docker run --name video2x-gpu3 \
  --device nvidia.com/gpu=3 \
  -it --rm \
  -e NVIDIA_DRIVER_CAPABILITIES=all \
  -e DATA_DIR=/data \
  -e TARGET_HEIGHT=1080 \
  -e PROCESSOR=realesrgan \
  -e REALESRGAN_MODEL=realesrgan-plus \
  -e SCALING_FACTOR=4 \
  -v "$PWD/data":/data \
  -v /path/to/your/local/video2x_models:/usr/share/video2x \
  registry.cn-qingdao.aliyuncs.com/wod/video2x:6.4.0
```

不设置 `SCALING_FACTOR` 时，批量入口会根据输入视频高度自动选择 `2`、`3` 或 `4` 倍，使输出高度不低于 `TARGET_HEIGHT`；由于 Real-ESRGAN 只能整数倍放大，输出高度可能高于 1080p。

### 多 GPU 机器运行方式

本镜像不需要特权模式。按运维要求使用 NVIDIA CDI 设备写法：`--device nvidia.com/gpu=N`。多 GPU 机器上建议只把需要的 GPU 暴露给容器，而不是把全部 GPU 暴露给容器后再用环境变量屏蔽。

单卡示例，绑定 GPU 3：

```bash
docker run --name video2x-gpu3 \
  --device nvidia.com/gpu=3 \
  -d --rm \
  -e NVIDIA_DRIVER_CAPABILITIES=all \
  -e DATA_DIR=/data \
  -e TARGET_HEIGHT=1080 \
  -e PROCESSOR=realesrgan \
  -e REALESRGAN_MODEL=realesrgan-plus \
  -e SCALING_FACTOR=4 \
  -v "$PWD/data":/data \
  -v /path/to/your/local/video2x_models:/usr/share/video2x \
  registry.cn-qingdao.aliyuncs.com/wod/video2x:6.4.0
```

如果确实要在一个容器内暴露多张卡，可重复声明 CDI 设备：

```bash
docker run --name video2x-gpu2-3 \
  --device nvidia.com/gpu=2 \
  --device nvidia.com/gpu=3 \
  -d --rm \
  -e NVIDIA_DRIVER_CAPABILITIES=all \
  -e DATA_DIR=/data \
  -e TARGET_HEIGHT=1080 \
  -e PROCESSOR=realesrgan \
  -e REALESRGAN_MODEL=realesrgan-plus \
  -e SCALING_FACTOR=4 \
  -v "$PWD/data":/data \
  -v /path/to/your/local/video2x_models:/usr/share/video2x \
  registry.cn-qingdao.aliyuncs.com/wod/video2x:6.4.0
```

如果要多张卡并行跑不同任务，推荐启动多个容器，每个容器绑定一张 GPU，并挂载不同的数据目录，例如 `video2x-gpu0` 处理 `/data/jasna/ai0`，`video2x-gpu1` 处理 `/data/jasna/ai1`。

### 模型下载说明

Video2X 6.4.0 使用的是源码仓库里自带的 ncnn/Vulkan 模型文件，即一组 `.param` + `.bin`，不是 Python 版 Real-ESRGAN 的 `.pth` 权重。Release 页面没有单独的模型压缩包；模型文件在源码路径 `models/realesrgan/` 下，运行时应放在容器内的 `/usr/share/video2x/models/realesrgan/`，或者当前工作目录下的 `models/realesrgan/`。

推荐优先下载 `realesrgan-plus-x4`：

- 普通实拍、电影、电视剧、通用视频：用 `realesrgan-plus`，也就是下载 `realesrgan-plus-x4.param` 和 `realesrgan-plus-x4.bin`。
- 动画/番剧视频：优先用 `realesr-animevideov3`，按放大倍率下载 `x2`、`x3` 或 `x4`。如果不确定倍率，就先下载 `x4`。
- 动漫图片或偏插画的视频：可以试 `realesrgan-plus-anime-x4`，但视频场景通常先试 `realesr-animevideov3`。

手动下载通用模型：

```bash
MODEL_DIR=/path/to/your/local/video2x_models/models/realesrgan
BASE_URL=https://raw.githubusercontent.com/k4yt3x/video2x/6.4.0/models/realesrgan

mkdir -p "$MODEL_DIR"
curl -L -o "$MODEL_DIR/realesrgan-plus-x4.param" "$BASE_URL/realesrgan-plus-x4.param"
curl -L -o "$MODEL_DIR/realesrgan-plus-x4.bin" "$BASE_URL/realesrgan-plus-x4.bin"
```

如果处理动画视频，改下模型名即可：

```bash
MODEL_DIR=/path/to/your/local/video2x_models/models/realesrgan
BASE_URL=https://raw.githubusercontent.com/k4yt3x/video2x/6.4.0/models/realesrgan

mkdir -p "$MODEL_DIR"
curl -L -o "$MODEL_DIR/realesr-animevideov3-x4.param" "$BASE_URL/realesr-animevideov3-x4.param"
curl -L -o "$MODEL_DIR/realesr-animevideov3-x4.bin" "$BASE_URL/realesr-animevideov3-x4.bin"
```

运行容器时，把本地模型目录挂载到 `/usr/share/video2x`：

```bash
docker run --device nvidia.com/gpu=0 -it --rm \
  -e NVIDIA_DRIVER_CAPABILITIES=all \
  -v "$PWD":/host \
  -v /path/to/your/local/video2x_models:/usr/share/video2x \
  registry.cn-qingdao.aliyuncs.com/wod/video2x:6.4.0 \
  -i /host/input.mp4 \
  -o /host/output_1080p.mp4 \
  -p realesrgan \
  -s 4 \
  --realesrgan-model realesrgan-plus
```

可用模型文件列表来自 Video2X 6.4.0 源码的 `models/realesrgan/` 目录：

- `realesrgan-plus-x4.param` / `realesrgan-plus-x4.bin`
- `realesrgan-plus-anime-x4.param` / `realesrgan-plus-anime-x4.bin`
- `realesr-animevideov3-x2.param` / `realesr-animevideov3-x2.bin`
- `realesr-animevideov3-x3.param` / `realesr-animevideov3-x3.bin`
- `realesr-animevideov3-x4.param` / `realesr-animevideov3-x4.bin`

Real-ESRGAN 官方 ncnn 说明可参考 [Real-ESRGAN-ncnn-vulkan](https://github.com/xinntao/Real-ESRGAN-ncnn-vulkan)，Python 版 `.pth` 权重说明可参考 [Real-ESRGAN](https://github.com/xinntao/Real-ESRGAN)。

## Github Actions 工作流

本目录中的 `dockerfile` 用于包装基础镜像。实际同步流程在 `.github/workflows/video2x.yml` 中定义：

- **触发条件**：向 `video2x` 分支提交代码，或手动在 Actions 页面点击触发 (Workflow Dispatch)。
- **目标镜像**：`registry.cn-qingdao.aliyuncs.com/wod/video2x:6.4.0`

## 构建

### CI 自动构建

推送到 `video2x` 分支即触发 GitHub Actions 自动构建：

```bash
git switch video2x && \
  git merge main --ff-only && \
  git push origin video2x && \
  git switch main
```

```powershell
git switch video2x ;`
  git merge main --ff-only ;`
  git push origin video2x ;`
  git switch main
```
