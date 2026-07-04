FROM registry.cn-qingdao.aliyuncs.com/wod/pytorch:2.4.1-cuda12.4-cudnn9-devel

USER root

ARG DEBIAN_FRONTEND=noninteractive
ARG RVC_VERSION=2.2.231006
ARG PYTORCH_CUDA_INDEX_URL=https://download.pytorch.org/whl/cu124

LABEL github_repo="https://github.com/RVC-Project/Retrieval-based-Voice-Conversion-WebUI"

RUN set -x \
    && apt-get update \
    && apt-get -y install wget curl man git less openssl libssl-dev unzip unar build-essential aria2 tmux vim \
    && apt-get install -y openssh-server sox libsox-fmt-all libsox-fmt-mp3 libsndfile1-dev ffmpeg \
    && apt-get install -y librdmacm1 libibumad3 librdmacm-dev libibverbs1 libibverbs-dev ibverbs-utils ibverbs-providers \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

WORKDIR /workspace

COPY requirements.txt /tmp/rvc-requirements.txt
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

RUN pip install --no-cache-dir --no-deps --index-url "${PYTORCH_CUDA_INDEX_URL}" \
    torchaudio==2.4.1 \
    torchvision==0.19.1

RUN git clone --branch "${RVC_VERSION}" --depth 1 \
    https://github.com/RVC-Project/Retrieval-based-Voice-Conversion-WebUI.git rvc \
    && rm -rf rvc/.git

RUN pip install --no-cache-dir --extra-index-url "${PYTORCH_CUDA_INDEX_URL}" \
    -r /tmp/rvc-requirements.txt

RUN pip check \
    && python -c "import torch; assert torch.__version__.split('+')[0] == '2.4.1', torch.__version__; import torchaudio; assert torchaudio.__version__.split('+')[0] == '2.4.1', torchaudio.__version__; import fairseq; import gradio; import faiss; import librosa; print('All imports OK')"

ENV SHELL=/bin/bash

VOLUME /workspace/rvc/assets/

EXPOSE 7865

WORKDIR /workspace/rvc

ENTRYPOINT ["entrypoint.sh"]
