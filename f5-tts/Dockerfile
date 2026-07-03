FROM pytorch/pytorch:2.4.0-cuda12.4-cudnn9-devel

USER root

ARG DEBIAN_FRONTEND=noninteractive
ARG F5_TTS_VERSION=1.1.20

LABEL github_repo="https://github.com/SWivid/F5-TTS"

RUN set -x \
    && apt-get update \
    && apt-get -y install wget curl man git less openssl libssl-dev unzip unar build-essential aria2 tmux vim \
    && apt-get install -y openssh-server sox libsox-fmt-all libsox-fmt-mp3 libsndfile1-dev ffmpeg \
    && apt-get install -y librdmacm1 libibumad3 librdmacm-dev libibverbs1 libibverbs-dev ibverbs-utils ibverbs-providers \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

WORKDIR /workspace

# Pin torch ecosystem versions compatible with PyTorch 2.4.0
RUN pip install --no-cache-dir \
    torchaudio==2.4.0 \
    torchvision==0.19.0

RUN git clone --branch "${F5_TTS_VERSION}" https://github.com/SWivid/F5-TTS.git \
    && cd F5-TTS \
    && git submodule update --init --recursive \
    && pip install -e . --no-cache-dir --no-deps

# Install remaining deps without touching torch/torchaudio/torchvision
RUN cd F5-TTS \
    && pip install --no-cache-dir \
    transformers==4.44.2 \
    accelerate \
    bitsandbytes \
    cached_path \
    click \
    einops \
    gradio \
    hydra-core \
    jieba \
    jinja2 \
    matplotlib \
    numpy \
    omegaconf \
    pydub \
    pypinyin \
    safetensors \
    soundfile \
    tomli \
    tqdm \
    vocos \
    wandb \
    x_transformers

ENV SHELL=/bin/bash

VOLUME /root/.cache/huggingface/hub/

EXPOSE 7860

WORKDIR /workspace/F5-TTS
