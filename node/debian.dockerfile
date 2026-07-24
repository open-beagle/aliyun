ARG BASE
ARG PNPM_VERSION=latest

FROM ${BASE}

ARG AUTHOR
ARG VERSION
ARG PNPM_VERSION=latest
LABEL maintainer=${AUTHOR} version=${VERSION}

RUN npm config set registry https://registry.npmmirror.com && \
  npm install -g pnpm@${PNPM_VERSION} && \
  pnpm config set registry https://registry.npmmirror.com
