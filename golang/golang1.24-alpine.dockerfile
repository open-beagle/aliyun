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
  apk --no-cache --update add git bash curl tzdata alpine-sdk linux-headers

RUN git config --global --add safe.directory '*'

WORKDIR /workspace
