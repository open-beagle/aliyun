ARG BASE=nvidia/cuda:12.9.1-cudnn-runtime-ubuntu24.04
FROM ${BASE}

ARG FACEFUSION_VERSION=3.7.1
ARG DEBIAN_FRONTEND=noninteractive

LABEL github_repo="https://github.com/facefusion/facefusion"
LABEL docker_repo="https://github.com/facefusion/facefusion-docker"

ENV GRADIO_SERVER_NAME=0.0.0.0 \
    GRADIO_SERVER_PORT=7860 \
    PIP_BREAK_SYSTEM_PACKAGES=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONUTF8=1

WORKDIR /facefusion

RUN set -eux; \
    if [ -f /etc/apt/sources.list.d/ubuntu.sources ]; then \
        sed -i 's/archive.ubuntu.com/azure.archive.ubuntu.com/g' /etc/apt/sources.list.d/ubuntu.sources; \
        sed -i 's/security.ubuntu.com/azure.archive.ubuntu.com/g' /etc/apt/sources.list.d/ubuntu.sources; \
    fi; \
    if [ -f /etc/apt/sources.list ]; then \
        sed -i 's/archive.ubuntu.com/azure.archive.ubuntu.com/g' /etc/apt/sources.list; \
        sed -i 's/security.ubuntu.com/azure.archive.ubuntu.com/g' /etc/apt/sources.list; \
    fi; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        ffmpeg \
        git \
        libgl1 \
        libglib2.0-0 \
        python-is-python3 \
        python3 \
        python3-pip; \
    if ! command -v pip >/dev/null 2>&1 && command -v pip3 >/dev/null 2>&1; then \
        ln -s "$(command -v pip3)" /usr/local/bin/pip; \
    fi; \
    rm -rf /var/lib/apt/lists/*; \
    apt-get clean

RUN git clone --branch "${FACEFUSION_VERSION}" --single-branch --depth 1 \
        https://github.com/facefusion/facefusion.git . \
    && python install.py cuda --skip-conda \
    && python -c "import cv2, gradio, onnxruntime as ort; providers = ort.get_available_providers(); assert 'CUDAExecutionProvider' in providers, providers; print('FaceFusion CUDA install OK:', providers)" \
    && rm -rf /root/.cache/pip .git

VOLUME ["/facefusion/.assets", "/facefusion/.caches", "/facefusion/.jobs"]

EXPOSE 7860

ENTRYPOINT ["python", "facefusion.py"]
CMD ["run", "--execution-providers", "cuda"]
