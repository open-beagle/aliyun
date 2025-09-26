ARG BASE

FROM ${BASE}

ARG AUTHOR
ARG VERSION
LABEL maintainer=${AUTHOR} version=${VERSION}

COPY ./ssl/beagle-ca.crt /usr/local/share/ca-certificates/beagle-ca.crt

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && \
  cat  /etc/apk/repositories && \
  apk --no-cache --update add bash ca-certificates tzdata curl iptables iproute2 && \
  cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
  update-ca-certificates && \
  echo "Asia/Shanghai" >  /etc/timezone