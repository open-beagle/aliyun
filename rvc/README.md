# RVC (Retrieval-based Voice Conversion)

## Github 地址

- 上游项目：https://github.com/RVC-Project/Retrieval-based-Voice-Conversion-WebUI

## 迭代命令

```bash
git switch rvc && \
  git merge main --ff-only && \
  git push origin rvc && \
  git switch main
```

```powershell
git switch rvc ;`
  git merge main --ff-only ;`
  git push origin rvc ;`
  git switch main
```

## 概述

自定义构建 RVC 镜像（Retrieval-based Voice Conversion WebUI）。

上游 Dockerfile 基于 `nvidia/cuda:11.6.2`（已 EOL），使用 Python 3.9（通过 PPA 安装），且在构建时从 HuggingFace 下载约 3GB 模型权重（CI 环境容易超时）。本 Dockerfile 做了以下改进：

- 基础镜像：`pytorch/pytorch:2.4.1-cuda12.4-cudnn9-devel`（与 f5-tts 一致）
- PyTorch 2.4.1（基础镜像自带）
- torchaudio 2.4.1
- torchvision 0.19.1
- 所有依赖版本锁定（来自上游 poetry.lock）
- 模型权重改为**运行时按需下载**，不嵌入镜像
- 固定上游 tag `2.2.231006`，保证可复现构建

GitHub Actions 工作流位于 `.github/workflows/rvc.yml`，推送 `rvc` 分支或手动触发工作流时执行构建。推送到：

- `registry.cn-qingdao.aliyuncs.com/wod/verdantflare-app:rvc-2.2.231006`

## 构建示例

```bash
docker build \
  --build-arg RVC_VERSION=2.2.231006 \
  -t verdantflare-app:rvc-2.2.231006 \
  ./rvc
```

## 运行示例

RVC 容器需要挂载权重目录和日志目录，并使用 GPU 运行。首次启动时会自动下载预训练模型：

```bash
docker run --gpus all --rm -it \
  -p 7865:7865 \
  -v $(pwd)/weights:/workspace/rvc/assets/weights \
  -v $(pwd)/models:/workspace/rvc/assets/pretrained_v2 \
  -v $(pwd)/opt:/workspace/rvc/opt \
  -v $(pwd)/logs:/workspace/rvc/logs \
  registry.cn-qingdao.aliyuncs.com/wod/verdantflare-app:rvc-2.2.231006
```

启动后可以通过浏览器访问 `http://localhost:7865` 使用 WebUI。

## 文件说明

| 文件               | 说明                                             |
| ------------------ | ------------------------------------------------ |
| `Dockerfile`       | 自定义构建文件，基于 PyTorch 2.4.1 + CUDA 12.4   |
| `requirements.txt` | 锁定版本的依赖列表，来自上游 poetry.lock         |
| `entrypoint.sh`    | 运行时入口脚本，按需下载模型并启动 WebUI         |
