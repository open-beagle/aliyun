FROM registry.cn-qingdao.aliyuncs.com/wod/pytorch:2.4.1-cuda12.4-cudnn9-devel

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

COPY pyproject.toml /tmp/f5-tts-pyproject.toml

RUN pip install --no-cache-dir --no-deps --index-url "${PYTORCH_CUDA_INDEX_URL}" \
    torchaudio==2.4.1 \
    torchvision==0.19.1

RUN git clone --branch "${F5_TTS_VERSION}" https://github.com/SWivid/F5-TTS.git \
    && cd F5-TTS \
    && git submodule update --init --recursive \
    && cp /tmp/f5-tts-pyproject.toml pyproject.toml \
    && pip install --no-cache-dir --extra-index-url "${PYTORCH_CUDA_INDEX_URL}" -e .

RUN pip check \
    && python -c "import torch; assert torch.__version__.split('+')[0] == '2.4.1', torch.__version__; import torchaudio; assert torchaudio.__version__.split('+')[0] == '2.4.1', torchaudio.__version__; import gradio; assert gradio.__version__ == '6.10.0', gradio.__version__; import torchcodec; import f5_tts.api; import f5_tts.model; import f5_tts.infer.utils_infer; import f5_tts.train.finetune_cli"

ENV SHELL=/bin/bash

VOLUME /root/.cache/huggingface/hub/

EXPOSE 7860

WORKDIR /workspace/F5-TTS
