FROM pytorch/pytorch:2.4.0-cuda12.4-cudnn9-devel

USER root

ARG DEBIAN_FRONTEND=noninteractive
ARG RVC_COMMIT=7ef19867780cf703841ebafb565a4e47d1ea86ff
ARG PYTORCH_CUDA_INDEX_URL=https://download.pytorch.org/whl/cu124

LABEL github_repo="https://github.com/RVC-Project/Retrieval-based-Voice-Conversion-WebUI"

RUN set -x \
    && apt-get update \
    && apt-get -y install wget curl man git less openssl libssl-dev unzip unar build-essential aria2 tmux vim \
    && apt-get install -y openssh-server sox libsox-fmt-all libsox-fmt-mp3 libsndfile1-dev ffmpeg \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

WORKDIR /workspace

COPY requirements.txt /tmp/rvc-requirements.txt
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

RUN pip install --no-cache-dir --no-deps --index-url "${PYTORCH_CUDA_INDEX_URL}" \
    torchaudio==2.4.0 \
    torchvision==0.19.0

RUN git clone https://github.com/RVC-Project/Retrieval-based-Voice-Conversion-WebUI.git rvc \
    && cd rvc \
    && git checkout "${RVC_COMMIT}"

RUN cd rvc \
    && pip install --no-cache-dir --extra-index-url "${PYTORCH_CUDA_INDEX_URL}" \
       -r /tmp/rvc-requirements.txt

RUN pip check || true \
    && python -c " \
import torch; assert torch.__version__.split('+')[0] == '2.4.0', torch.__version__; \
import torchaudio; assert torchaudio.__version__.split('+')[0] == '2.4.0', torchaudio.__version__; \
import fairseq; import gradio; import faiss; import librosa; import numpy; \
print('torch:', torch.__version__); \
print('torchaudio:', torchaudio.__version__); \
print('fairseq:', fairseq.__version__); \
print('gradio:', gradio.__version__); \
print('numpy:', numpy.__version__); \
print('All imports OK') \
"

ENV SHELL=/bin/bash

VOLUME ["/workspace/rvc/assets/weights", "/workspace/rvc/opt", "/workspace/rvc/logs"]

EXPOSE 7865

WORKDIR /workspace/rvc

ENTRYPOINT ["entrypoint.sh"]
