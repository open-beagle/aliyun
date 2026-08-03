ARG BASE
ARG PNPM_VERSION=latest

FROM ${BASE}

ARG AUTHOR
ARG VERSION
ARG PNPM_VERSION=latest
LABEL maintainer=${AUTHOR} version=${VERSION}

RUN (sed -i 's/deb.debian.org/debian-archive.trafficmanager.net/g' /etc/apt/sources.list.d/debian.sources 2>/dev/null || \
  sed -i 's/deb.debian.org/debian-archive.trafficmanager.net/g' /etc/apt/sources.list 2>/dev/null || true) && \
  apt-get update && \
  apt-get install -y --no-install-recommends git && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  npm install -g pnpm@${PNPM_VERSION} && \
  pnpm config set registry https://registry.npmmirror.com
