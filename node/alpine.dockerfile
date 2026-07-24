ARG BASE
ARG PNPM_VERSION=latest

FROM ${BASE}

ARG AUTHOR
ARG VERSION
ARG PNPM_VERSION=latest
LABEL maintainer=${AUTHOR} version=${VERSION}

COPY ./ssl/beagle-ca.crt /usr/local/share/ca-certificates/beagle-ca.crt

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && \
  cat  /etc/apk/repositories && \
  apk --no-cache --update add bash ca-certificates tzdata curl iptables iproute2 && \
  cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
  update-ca-certificates && \
  npm config set cafile /etc/ssl/certs/ca-certificates.crt && \
  echo "Asia/Shanghai" >  /etc/timezone && \
  npm install -g pnpm@${PNPM_VERSION} && \
  pnpm config set registry https://registry.npmmirror.com

ENV NODE_EXTRA_CA_CERTS=/etc/ssl/certs/ca-certificates.crt
