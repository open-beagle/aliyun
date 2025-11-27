ARG XXBASE=tonistiigi/xx:1.6.1
ARG BASE=golang:1.24-bookworm

FROM ${XXBASE} AS xx
FROM $BASE

ARG AUTHOR=mengkzhaoyun@gmail.com
ARG VERSION=1.24-bookworm
LABEL maintainer=${AUTHOR} version=${VERSION}

COPY --from=xx / /

ENV GOPROXY=https://goproxy.cn

RUN git config --global --add safe.directory '*'

RUN sed -i 's/http\:\/\/deb.debian.org/http\:\/\/ftp.cn.debian.org/g' /etc/apt/sources.list.d/debian.sources && \
  apt update -y && apt install apt-transport-https ca-certificates -y && \
  apt install -y rsync pkg-config build-essential && \
  apt clean

WORKDIR /workspace
