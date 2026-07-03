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

本目录用于同步 F5-TTS 镜像（Fairytaler that Fakes Fluent and Faithful Speech with Flow Matching），从上游 `ghcr.io/swivid/f5-tts:main` 拉取并推送到阿里云镜像仓库。

GitHub Actions 工作流位于 `.github/workflows/f5-tts.yml`，推送 `f5-tts` 分支或手动触发工作流时执行同步。当前同步版本为 `f5-main`，推送到：

- `registry.cn-qingdao.aliyuncs.com/wod/tts:f5-main`

## 运行示例

```bash
docker run --gpus all --rm -it \
  -p 7860:7860 \
  registry.cn-qingdao.aliyuncs.com/wod/tts:f5-main \
  f5-tts_infer-gradio --port 7860 --host 0.0.0.0
```
