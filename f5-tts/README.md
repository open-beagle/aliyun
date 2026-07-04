# F5-TTS

## Github 地址

- 上游项目：https://github.com/SWivid/F5-TTS

## 迭代命令

```bash
git switch f5-tts && \
  git merge main --ff-only && \
  git push origin f5-tts && \
  git switch main
```

```powershell
git switch f5-tts ;`
  git merge main --ff-only ;`
  git push origin f5-tts ;`
  git switch main
```

## 概述

自定义构建 F5-TTS 镜像（Fairytaler that Fakes Fluent and Faithful Speech with Flow Matching）。

- PyTorch 2.4.1（基础镜像自带）
- torchaudio 2.4.1
- torchvision 0.19.1
- transformers 4.44.2

GitHub Actions 工作流位于 `.github/workflows/f5-tts.yml`，推送 `f5-tts` 分支或手动触发工作流时执行构建。推送到：

- `registry.cn-qingdao.aliyuncs.com/wod/verdantflare-app:f5-tts-1.1.20`

## 运行示例

```bash
docker run --gpus all --rm -it \
  -p 7860:7860 \
  registry.cn-qingdao.aliyuncs.com/wod/verdantflare-app:f5-tts-1.1.20 \
  f5-tts_infer-gradio --port 7860 --host 0.0.0.0
```
