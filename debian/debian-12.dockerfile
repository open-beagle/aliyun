ARG BASE
FROM $BASE

ARG AUTHOR
ARG VERSION
LABEL maintainer=$AUTHOR version=$VERSION

COPY debian-12.sources /etc/apt/sources.list.d/debian.sources

ARG DEBIAN_FRONTEND=noninteractive
RUN apt update -y && \
  apt install -y ca-certificates && \
  apt-get clean && \
  rm -rf /etc/localtime && \
  ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
