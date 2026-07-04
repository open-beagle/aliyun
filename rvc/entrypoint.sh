#!/bin/bash
set -e

echo "=== RVC Entrypoint ==="

# Download pretrained models if not present
download_model() {
    local dir="$1"
    local file="$2"
    local target="./assets/${dir}/${file}"
    if [ ! -f "${target}" ]; then
        echo "Downloading ${dir}/${file} ..."
        aria2c --console-log-level=error -c -x 16 -s 16 -k 1M \
            "https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/${dir}/${file}" \
            -d "./assets/${dir}" -o "${file}" || \
            echo "WARNING: Failed to download ${file}, some features may not work"
    fi
}

download_special() {
    local dir="$1"
    local file="$2"
    local target="./assets/${dir}/${file}"
    if [ ! -f "${target}" ]; then
        echo "Downloading ${file} to ${dir} ..."
        aria2c --console-log-level=error -c -x 16 -s 16 -k 1M \
            "https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/${file}" \
            -d "./assets/${dir}" -o "${file}" || \
            echo "WARNING: Failed to download ${file}, some features may not work"
    fi
}

# Ensure directories exist
mkdir -p ./assets/pretrained ./assets/pretrained_v2 ./assets/uvr5_weights ./assets/uvr5_weights/onnx_dereverb_By_FoxJoy
mkdir -p ./assets/weights ./assets/rmvpe ./assets/hubert
mkdir -p ./logs

# Pretrained v1
download_model pretrained D32k.pth
download_model pretrained D40k.pth
download_model pretrained D48k.pth
download_model pretrained G32k.pth
download_model pretrained G40k.pth
download_model pretrained G48k.pth

# Pretrained v2
download_model pretrained_v2 D40k.pth
download_model pretrained_v2 G40k.pth
download_model pretrained_v2 f0D40k.pth
download_model pretrained_v2 f0G40k.pth

# UVR5 weights
download_model uvr5_weights HP2_all_vocals.pth
download_model uvr5_weights HP3_all_vocals.pth
download_model uvr5_weights HP5_only_main_vocal.pth
download_model uvr5_weights VR-DeEchoAggressive.pth
download_model uvr5_weights VR-DeEchoDeReverb.pth
download_model uvr5_weights VR-DeEchoNormal.pth
download_model uvr5_weights "onnx_dereverb_By_FoxJoy/vocals.onnx"

# Special models
download_special rmvpe rmvpe.pt
download_special hubert hubert_base.pt

echo "=== Model check complete ==="
echo "=== Starting RVC WebUI ==="

exec python3 infer-web.py --port 7865 --pycmd python3 "$@"
