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
  apk --no-cache --update add git bash curl tzdata alpine-sdk linux-headers shadow sudo

RUN git config --global --add safe.directory '*'

# 创建 UID 1000 的用户
RUN addgroup -g 1000 code && \
  adduser -D -u 1000 -G code -s /bin/bash code && \
  echo "code ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
  mkdir -p /home/code/go && \
  chown -R code:code /home/code

# 设置用户环境变量
ENV HOME=/home/code
ENV GOPATH=/home/code/go

USER code
WORKDIR /home/code
