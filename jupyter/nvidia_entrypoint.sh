#!/bin/bash

set -euo pipefail

export PATH="${VIRTUAL_ENV:-/opt/jupyter}/bin:$PATH"

BEAGLE_ROOT="${BEAGLE_ROOT:-/beagle}"

print_repeats() {
  local char="$1"
  local count="$2"
  local i

  for ((i = 1; i <= count; i++)); do
    echo -n "$char"
  done
  echo
}

print_banner_text() {
  local banner_char="$1"
  local text="$2"
  local pad="${banner_char}${banner_char}"

  print_repeats "$banner_char" $((${#text} + 6))
  echo "${pad} ${text} ${pad}"
  print_repeats "$banner_char" $((${#text} + 6))
}

install_jupyter_settings() {
  local home_dir="${HOME:-/root}"
  local config_dir="${JUPYTER_CONFIG_DIR:-$home_dir/.jupyter}"
  local settings_dir="$config_dir/lab/user-settings/@jupyterlab/translation-extension"

  if [ -f "${JUPYTER_SETTINGS_SOURCE:-}" ]; then
    mkdir -p "$settings_dir" 2>/dev/null || return
    cp "$JUPYTER_SETTINGS_SOURCE" "$settings_dir/plugin.jupyterlab-settings" 2>/dev/null || true
  fi
}

configure_ssh() {
  if [ "$(id -u)" != "0" ] || ! command -v sshd >/dev/null 2>&1; then
    return
  fi

  mkdir -p /run/sshd /etc/ssh/sshd_config.d
  {
    echo "PubkeyAuthentication yes"
    echo "PasswordAuthentication yes"
    if [ -n "${ROOT_PASSWORD:-}" ]; then
      echo "PermitRootLogin yes"
    fi
  } > /etc/ssh/sshd_config.d/beagle.conf

  if [ -n "${ROOT_PASSWORD:-}" ]; then
    echo "root:$ROOT_PASSWORD" | chpasswd
  fi

  service ssh start
}

run_beagle_hook() {
  mkdir -p "$BEAGLE_ROOT"

  if [ -n "${HOME:-}" ]; then
    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"
  fi

  if [ -f "$BEAGLE_ROOT/entrypoint.sh" ]; then
    sh "$BEAGLE_ROOT/entrypoint.sh" &
  fi
}

install_jupyter_settings
configure_ssh
run_beagle_hook

jupyter lab \
  --allow-root \
  --ip=0.0.0.0 \
  --no-browser \
  "--IdentityProvider.token=${ROOT_PASSWORD:-}" \
  "--ServerApp.root_dir=$BEAGLE_ROOT" &
sleep infinity
