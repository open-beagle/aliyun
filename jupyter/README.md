# jupyter

基于 NVIDIA CUDA runtime Ubuntu 24.04 镜像构建 JupyterLab 镜像，默认安装 Python venv、JupyterLab 和中文语言包。

## 镜像

- `registry.cn-qingdao.aliyuncs.com/wod/jupyter:12.6.3-runtime-ubuntu24.04`
- `registry.cn-qingdao.aliyuncs.com/wod/jupyter:12.8.2-runtime-ubuntu24.04`
- `registry.cn-qingdao.aliyuncs.com/wod/jupyter:13.0.3-runtime-ubuntu24.04`

## 构建

```bash
docker build \
  --build-arg BASE=nvidia/cuda:12.6.3-runtime-ubuntu24.04 \
  --build-arg AUTHOR=open-beagle \
  --build-arg VERSION=12.6.3-runtime-ubuntu24.04 \
  -t registry.cn-qingdao.aliyuncs.com/wod/jupyter:12.6.3-runtime-ubuntu24.04 \
  -f jupyter/dockerfile .
```

当前 CUDA runtime Ubuntu 24.04 使用 NVIDIA supported tags 中对应小版本的最新 patch：`12.6.3`、`12.8.2`、`13.0.3`。

## 推送

```bash
docker push registry.cn-qingdao.aliyuncs.com/wod/jupyter:12.6.3-runtime-ubuntu24.04
```

## 运行

```bash
docker run --rm -it \
  --gpus all \
  -p 8888:8888 \
  -p 2222:22 \
  -e ROOT_PASSWORD=password \
  registry.cn-qingdao.aliyuncs.com/wod/jupyter:12.6.3-runtime-ubuntu24.04
```
