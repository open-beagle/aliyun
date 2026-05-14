# Video2X (Aliyun Mirror)

此目录包含了同步 `ghcr.io/k4yt3x/video2x` 到阿里云容器镜像服务的相关配置。

## 如何运行

您可以通过以下命令使用阿里云镜像运行 Video2X。为了避免每次运行容器时都重新下载模型，建议您在宿主机上挂载一个模型缓存目录。

Video2X 默认会将下载的模型保存在 `/root/.local/share/video2x` 或 `/root/.cache/video2x` 下（由于基于 Linux 环境）。我们建议通过 `-v` 将本地目录挂载进去。

### 运行示例

```bash
# 创建一个本地目录用于存放模型
mkdir -p /path/to/your/local/video2x_models

# 运行 Video2X 并挂载模型目录和工作目录
docker run --gpus all --privileged -it --rm \
  -v "$PWD":/host \
  -v /path/to/your/local/video2x_models:/root/.local/share/video2x \
  -v /path/to/your/local/video2x_models_cache:/root/.cache/video2x \
  registry.cn-qingdao.aliyuncs.com/wod/video2x:6.1.1 \
  -i /host/input.mp4 \
  -o /host/output_1080p.mp4 \
  -p realesrgan \
  -h 1080 \
  --realesrgan-model realesrgan-x4plus
```

### 批量转换 data 目录

镜像入口会扫描容器内 `/data` 目录下的 `*.mp4` 文件，找出高度低于 `1080p` 的视频，先列出任务清单，再逐个转换为同目录下的 `*_1080p.mp4`。

```bash
docker run --gpus all --privileged -it --rm \
  -v "$PWD/data":/data \
  -v /path/to/your/local/video2x_models:/root/.local/share/video2x \
  -v /path/to/your/local/video2x_models_cache:/root/.cache/video2x \
  registry.cn-qingdao.aliyuncs.com/wod/video2x:6.1.1
```

可通过环境变量调整默认参数：

```bash
docker run --gpus all --privileged -it --rm \
  -e DATA_DIR=/data \
  -e TARGET_HEIGHT=1080 \
  -e PROCESSOR=realesrgan \
  -e REALESRGAN_MODEL=realesrgan-x4plus \
  -v "$PWD/data":/data \
  -v /path/to/your/local/video2x_models:/root/.local/share/video2x \
  -v /path/to/your/local/video2x_models_cache:/root/.cache/video2x \
  registry.cn-qingdao.aliyuncs.com/wod/video2x:6.1.1
```

### 模型下载说明

1. **自动下载**：Video2X 具有自动下载机制。在您首次运行某个特定的处理流（如 `realesrgan`）时，如果在容器内的缓存目录中找不到对应的模型文件，程序会自动从 GitHub 发布页下载所需的模型。
2. **持久化存储**：通过如上所示的挂载 `-v /path/to/your/local/video2x_models:/root/.local/share/video2x` 和 `-v /path/to/your/local/video2x_models_cache:/root/.cache/video2x`，容器自动下载的模型会保留在宿主机上。后续再次运行或重建容器时，只要继续挂载该目录，就无需重新下载模型。
3. **手动下载**：如果您所在的网络环境无法直连 GitHub，您可以前往相应模型的仓库（例如 [Real-ESRGAN](https://github.com/xinntao/Real-ESRGAN)）下载模型权重文件，并手动放置到您挂载的本地目录的对应路径中。具体路径会在首次运行报错时在日志中提示，通常位于 `realesrgan/weights/` 等相对位置。

## Github Actions 工作流

本目录中的 `dockerfile` 用于包装基础镜像。实际同步流程在 `.github/workflows/video2x.yml` 中定义：

- **触发条件**：向 `video2x` 分支提交代码，或手动在 Actions 页面点击触发 (Workflow Dispatch)。
- **目标镜像**：`registry.cn-qingdao.aliyuncs.com/wod/video2x:6.1.1`

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
