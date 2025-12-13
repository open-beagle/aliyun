ARG XXBASE=tonistiigi/xx:1.6.1
ARG BASE=golang:1.24-alpine

FROM ${XXBASE} AS xx
FROM ${BASE}

ARG AUTHOR=mengkzhaoyun@gmail.com
ARG VERSION=1.24-alpine
LABEL maintainer=${AUTHOR} version=${VERSION}

COPY --from=xx / /

ENV GOPROXY=https://goproxy.cn

RUN sed -i "s@dl-cdn.alpinelinux.org@mirrors.aliyun.com@g" /etc/apk/repositories && \
  apk update && \
  apk --no-cache --update add git bash curl tzdata alpine-sdk linux-headers sudo

RUN git config --global --add safe.directory '*'

RUN addgroup -g 1000 code && \
  adduser -D -u 1000 -G code -h /home/code -s /bin/bash code && \
  echo "code ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
  echo 'export GOPROXY=https://goproxy.cn' >> /home/code/.bashrc && \
  echo 'export GOPATH=/home/code/go' >> /home/code/.bashrc && \
  echo 'export GOCACHE=/home/code/.cache/go-build' >> /home/code/.bashrc && \
  echo 'export GOMODCACHE=/home/code/go/pkg/mod' >> /home/code/.bashrc

WORKDIR /workspace
