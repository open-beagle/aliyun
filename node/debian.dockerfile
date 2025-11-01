ARG BASE

FROM ${BASE}

ARG AUTHOR
ARG VERSION
LABEL maintainer=${AUTHOR} version=${VERSION}

COPY ./ssl/beagle-ca.crt /usr/local/share/ca-certificates/beagle-ca.crt

ARG DEBIAN_FRONTEND=noninteractive
RUN apt update -y && \
  apt install -y ca-certificates && \
  apt-get clean && \
  rm -rf /etc/localtime && \
  ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
