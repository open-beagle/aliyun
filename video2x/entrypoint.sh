#!/usr/bin/env bash
set -euo pipefail

DATA_DIR="${DATA_DIR:-/data}"
TARGET_HEIGHT="${TARGET_HEIGHT:-1080}"
PROCESSOR="${PROCESSOR:-realesrgan}"
REALESRGAN_MODEL="${REALESRGAN_MODEL:-realesrgan-plus}"
SCALING_FACTOR="${SCALING_FACTOR:-}"

if [ "$#" -gt 0 ]; then
  exec video2x "$@"
fi

if ! command -v ffprobe >/dev/null 2>&1; then
  echo "error: ffprobe is required but was not found in PATH" >&2
  exit 1
fi

if ! command -v video2x >/dev/null 2>&1; then
  echo "error: video2x is required but was not found in PATH" >&2
  exit 1
fi

if [ ! -d "$DATA_DIR" ]; then
  echo "error: data directory does not exist: $DATA_DIR" >&2
  exit 1
fi

declare -a INPUTS=()
declare -a OUTPUTS=()
declare -a DIMENSIONS=()

while IFS= read -r -d '' input; do
  base="${input%.*}"

  if [[ "$base" == *_1080p ]]; then
    continue
  fi

  output="${base}_1080p.mp4"
  if [ -e "$output" ]; then
    echo "skip existing output: $output"
    continue
  fi

  dimensions="$(
    ffprobe -v error \
      -select_streams v:0 \
      -show_entries stream=width,height \
      -of csv=s=x:p=0 \
      "$input" || true
  )"

  if [ -z "$dimensions" ]; then
    echo "skip unreadable video: $input"
    continue
  fi

  height="${dimensions#*x}"

  if ! [[ "$height" =~ ^[0-9]+$ ]]; then
    echo "skip video with unknown height: $input ($dimensions)"
    continue
  fi

  if [ "$height" -lt "$TARGET_HEIGHT" ]; then
    INPUTS+=("$input")
    OUTPUTS+=("$output")
    DIMENSIONS+=("$dimensions")
  fi
done < <(find "$DATA_DIR" -type f -iname '*.mp4' -print0)

if [ "${#INPUTS[@]}" -eq 0 ]; then
  echo "No mp4 files below ${TARGET_HEIGHT}p were found in $DATA_DIR."
  exit 0
fi

echo "Tasks to convert to ${TARGET_HEIGHT}p:"
for index in "${!INPUTS[@]}"; do
  printf '  %d. %s (%s) -> %s\n' \
    "$((index + 1))" \
    "${INPUTS[$index]}" \
    "${DIMENSIONS[$index]}" \
    "${OUTPUTS[$index]}"
done

for index in "${!INPUTS[@]}"; do
  echo
  printf '[%d/%d] converting: %s\n' \
    "$((index + 1))" \
    "${#INPUTS[@]}" \
    "${INPUTS[$index]}"

  input_height="${DIMENSIONS[$index]#*x}"
  scale="${SCALING_FACTOR:-$(((TARGET_HEIGHT + input_height - 1) / input_height))}"
  if [ "$scale" -lt 2 ]; then
    scale=2
  elif [ "$scale" -gt 4 ]; then
    scale=4
  fi

  video2x \
    -i "${INPUTS[$index]}" \
    -o "${OUTPUTS[$index]}" \
    -p "$PROCESSOR" \
    -s "$scale" \
    --realesrgan-model "$REALESRGAN_MODEL"
done

echo
echo "All tasks completed."
