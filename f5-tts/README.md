# F5-TTS

> 🚨 **【强制性规则】绝对禁止直接在触发分支上发起任何提交或修改！**  
> 所有配置变更、镜像版本升级必须且只能在 `main` 分支完成。触发分支仅作为 CI/CD 自动构建的专用触发分支。

---

## 🚫 严禁事项与操作铁律

1. **禁止直接 Commit**：不得擅自在构建分支修改 Dockerfile、README 或工作流。
2. **禁止产生脏 Merge 提交**：若出现 `refusing to merge unrelated histories` 报错，**严禁**使用常规 `git merge` 或乱加参数强行合并，必须统一使用 `git reset --hard main` 强制对齐主干历史！
3. **保持提交历史纯粹**：触发分支的 HEAD 必须镜像级对齐 `main` 分支。

---

## Github 地址

- 上游项目：https://github.com/SWivid/F5-TTS

## 🔄 标准迭代与强制对齐命令

```bash
git switch f5-tts && \
  git reset --hard main && \
  git push origin f5-tts --force && \
  git switch main
```

```powershell
git switch f5-tts ;`
  git reset --hard main ;`
  git push origin f5-tts --force ;`
  git switch main
```

## 📌 概述与镜像构建说明

自定义构建 F5-TTS 镜像（Fairytaler that Fakes Fluent and Faithful Speech with Flow Matching）。

- PyTorch 2.4.1（基础镜像自带）
- torchaudio 2.4.1
- torchvision 0.19.1
- transformers 4.44.2

GitHub Actions 工作流位于 `.github/workflows/f5-tts.yml`，推送 `f5-tts` 分支或手动触发工作流时执行构建。推送到：

- `registry.cn-qingdao.aliyuncs.com/wod/verdantflare-app:f5-tts-1.1.20`

## 构建示例

```bash
docker build \
  --build-arg BASE=registry.cn-qingdao.aliyuncs.com/wod/pytorch:2.4.1-cuda12.4-cudnn9-devel \
  --build-arg F5_TTS_VERSION=1.1.20 \
  -t verdantflare-app:f5-tts-1.1.20 \
  ./f5-tts
```

## 运行示例

```bash
docker run --gpus all --rm -it \
  -p 7860:7860 \
  registry.cn-qingdao.aliyuncs.com/wod/verdantflare-app:f5-tts-1.1.20 \
  f5-tts_infer-gradio --port 7860 --host 0.0.0.0
```
