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
  apt install -y rsync pkg-config sudo build-essential && \
  apt clean

# 创建 UID 1000 的用户
RUN groupadd -g 1000 golang && \
  useradd -m -u 1000 -g golang -s /bin/bash golang && \
  echo "golang ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
  mkdir -p /home/golang/go && \
  chown -R golang:golang /home/golang

# 设置用户环境变量
ENV HOME=/home/golang
ENV GOPATH=/home/golang/go

USER golang
WORKDIR /home/golang
