FROM pytorch/pytorch:2.4.0-cuda12.4-cudnn9-devel

USER root

ARG DEBIAN_FRONTEND=noninteractive
ARG F5_TTS_VERSION=1.1.20
ARG PYTORCH_CUDA_INDEX_URL=https://download.pytorch.org/whl/cu124

LABEL github_repo="https://github.com/SWivid/F5-TTS"

RUN set -x \
    && apt-get update \
    && apt-get -y install wget curl man git less openssl libssl-dev unzip unar build-essential aria2 tmux vim \
    && apt-get install -y openssh-server sox libsox-fmt-all libsox-fmt-mp3 libsndfile1-dev ffmpeg \
    && apt-get install -y librdmacm1 libibumad3 librdmacm-dev libibverbs1 libibverbs-dev ibverbs-utils ibverbs-providers \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

WORKDIR /workspace

# Keep the PyTorch stack on the CUDA 12.4 ABI shipped by the base image.
# TorchCodec 0.0.3 is the last release matching torch 2.4.
RUN printf '%s\n' \
    'torch==2.4.0' \
    'torchaudio==2.4.0' \
    'torchvision==0.19.0' \
    'triton==3.0.0' \
    'torchcodec==0.0.3' \
    'gradio==6.10.0' \
    'huggingface-hub==0.36.2' \
    'numpy==1.26.4' \
    'transformers==4.44.2' \
    > /tmp/f5-tts-constraints.txt

RUN pip install --no-cache-dir --no-deps --index-url "${PYTORCH_CUDA_INDEX_URL}" \
    torchaudio==2.4.0 \
    torchvision==0.19.0

RUN git clone --branch "${F5_TTS_VERSION}" https://github.com/SWivid/F5-TTS.git \
    && cd F5-TTS \
    && git submodule update --init --recursive \
    && pip install --no-cache-dir --extra-index-url "${PYTORCH_CUDA_INDEX_URL}" --constraint /tmp/f5-tts-constraints.txt -e . psutil

RUN pip check \
    && python -c "import torch; assert torch.__version__.split('+')[0] == '2.4.0', torch.__version__; import torchaudio; assert torchaudio.__version__.split('+')[0] == '2.4.0', torchaudio.__version__; import gradio; assert gradio.__version__ == '6.10.0', gradio.__version__; import torchcodec; import f5_tts.model; import f5_tts.infer.infer_cli; import f5_tts.train.finetune_cli"

ENV SHELL=/bin/bash

VOLUME /root/.cache/huggingface/hub/

EXPOSE 7860

WORKDIR /workspace/F5-TTS
