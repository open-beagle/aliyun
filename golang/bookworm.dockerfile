ARG XXBASE=tonistiigi/xx:1.6.1
ARG BASE=golang:1.24-bookworm

FROM ${XXBASE} AS xx
FROM $BASE

ARG AUTHOR=mengkzhaoyun@gmail.com
ARG VERSION=1.24-bookworm
ARG GOPROXY=https://goproxy.cn
LABEL maintainer=${AUTHOR} version=${VERSION}

COPY --from=xx / /

ENV GOPROXY=${GOPROXY}
ENV TZ=Asia/Shanghai

RUN git config --global --add safe.directory '*'

RUN sed -i \
    -e 's@http://deb.debian.org/debian-security@http://security.debian.org/debian-security@g' \
    -e 's@http://deb.debian.org/debian@http://ftp.us.debian.org/debian@g' \
    /etc/apt/sources.list.d/debian.sources && \
  apt update -y && apt install apt-transport-https ca-certificates -y && \
  apt install -y rsync pkg-config build-essential crossbuild-essential-arm64 sudo tzdata && \
  ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
  echo "Asia/Shanghai" > /etc/timezone && \
  apt clean

RUN groupadd -g 1000 code && \
  useradd -m -u 1000 -g 1000 -d /home/code -s /bin/bash code && \
  echo "code ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
  echo "export GOPROXY=${GOPROXY}" >> /home/code/.bashrc && \
  echo 'export GOPATH=/home/code/go' >> /home/code/.bashrc && \
  echo 'export GOCACHE=/home/code/.cache/go-build' >> /home/code/.bashrc && \
  echo 'export GOMODCACHE=/home/code/go/pkg/mod' >> /home/code/.bashrc

WORKDIR /workspace
