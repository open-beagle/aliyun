#!/bin/bash
set -e

# ============================================================
# Jasna Docker Entrypoint
#
# 用法:
#   jasna --input ... --output ...    # 正常处理视频
#   jasna --stream                    # 流媒体模式
#   jasna warmup [选项]               # 预编译 TensorRT 引擎
# ============================================================

if [ "$1" = "warmup" ]; then
    shift

    CLIP_SIZE="${CLIP_SIZE:-90}"
    BATCH_SIZE="${BATCH_SIZE:-4}"
    DETECTION_MODEL="${DETECTION_MODEL:-rfdetr-v5}"
    RESTORATION_MODEL="${RESTORATION_MODEL:-model_weights/lada_mosaic_restoration_model_generic_v1.2.pth}"
    DETECTION_MODEL_PATH="${DETECTION_MODEL_PATH:-model_weights/${DETECTION_MODEL}.onnx}"

    echo "============================================"
    echo " Jasna TensorRT Engine Warmup"
    echo "============================================"
    echo " Clip Size:         ${CLIP_SIZE}"
    echo " Batch Size:        ${BATCH_SIZE}"
    echo " Detection Model:   ${DETECTION_MODEL}"
    echo " Restoration Model: ${RESTORATION_MODEL}"
    echo "============================================"
    echo ""
    echo "编译 TensorRT 引擎中, 首次需要 15-60 分钟..."
    echo "引擎会缓存到 model_weights/ 目录, 后续启动无需重新编译。"
    echo ""

    python -m jasna.engine_compiler "$(python -c "
import json
print(json.dumps({
    'device': 'cuda:0',
    'fp16': True,
    'basicvsrpp': True,
    'basicvsrpp_model_path': '${RESTORATION_MODEL}',
    'basicvsrpp_max_clip_size': ${CLIP_SIZE},
    'detection': True,
    'detection_model_name': '${DETECTION_MODEL}',
    'detection_model_path': '${DETECTION_MODEL_PATH}',
    'detection_batch_size': ${BATCH_SIZE},
    'unet4x': False,
}))
")"

    echo ""
    echo "============================================"
    echo " Warmup 完成! 引擎已缓存。"
    echo "============================================"
    exit 0
fi

exec jasna "$@"
